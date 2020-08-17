defmodule AmSaml do
  @moduledoc """
  Provides auth-related functions.
  """
  alias AmSaml.{Decoder, Encoder, Generator, Validator}

  @doc """
  Provides the redirect url to the saml_provider
  """
  def auth_redirect(relay_state) do
    idp_url = Application.get_env(:am_saml, :saml_idp_url)
    issuer = Application.get_env(:am_saml, :saml_issuer)
    ~s{#{idp_url}?SAMLRequest=#{Encoder.auth_request(issuer)}&RelayState=#{Base.url_encode64(relay_state)}}
  end

  @doc """
  Handles the authentication from the saml_response and fields user provides

  Returns a map with fields provided in it, note that should exist in order to fetch them from the saml response.

  ## Example

      iex> AmSaml.auth(%{"RelayState" => "http://yoursite.com/existing_url/", "SAMLResponse" => "saml_response"}, ["foo", "bar"])
      %{"RelayState" => "http://yoursite.com/existing_url/", "SAMLResponse" => "saml_response", "foo" => "foo", "bar" => "bar"}

  """
  def auth(%{"RelayState" => relay_state, "SAMLResponse" => saml_response}, fields) do
    %{c: cert, a: audience, i: issue_instant, d: doc} = Decoder.saml_response(saml_response)

    saml_cert = Application.get_env(:am_saml, :saml_cert)
    saml_audience = Application.get_env(:am_saml, :saml_audience)

    if Validator.valid_cert?(cert, saml_cert) && Validator.valid_audience?(audience, saml_audience) do
      Generator.saml_response(relay_state, issue_instant, doc, fields)
    else
      nil
    end
  end
end
