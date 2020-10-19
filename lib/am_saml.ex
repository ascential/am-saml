defmodule AmSaml do
  @moduledoc """
  Provides auth-related functions.
  """
  alias AmSaml.{Decoder, Encoder, Generator, Validator}

  @doc """
  Provides the redirect url to the saml_provider
  """
  def auth_redirect(relay_state) do
    idp_url = Application.get_env(:am_saml, :idp_url)
    issuer = Application.get_env(:am_saml, :issuer)
    auth_redirect(relay_state, idp_url, issuer)
  end

  def auth_redirect(relay_state, idp_url, issuer) do
    ~s{#{idp_url}?SAMLRequest=#{Encoder.auth_request(issuer)}&RelayState=#{Base.url_encode64(relay_state)}}
  end

  @doc """
  Handles the authentication from the saml_response and fields user provides

  Returns a map with fields provided in it, note that should exist in order to fetch them from the saml response.

  ## Example

      iex> AmSaml.auth(%{"RelayState" => "http://yoursite.com/existing_url/", "SAMLResponse" => "saml_response"}, ["foo", "bar"])
      %{"RelayState" => "http://yoursite.com/existing_url/", "SAMLResponse" => "saml_response", "foo" => "foo", "bar" => "bar"}

  """
  def auth(saml_info, fields \\ []) do
    saml_cert = Application.get_env(:am_saml, :cert)
    saml_audience = Application.get_env(:am_saml, :audience)
    auth(saml_info, saml_cert, saml_audience, fields)
  end
  def auth(saml_info, saml_cert, saml_audience, fields \\ []) do
    %{"RelayState" => relay_state, "SAMLResponse" => saml_response} = saml_info
    %{c: cert, a: audience, i: issue_instant, d: doc} = Decoder.saml_response(saml_response)

    if Validator.valid_cert?(cert, saml_cert) && Validator.valid_audience?(audience, saml_audience) do
      Generator.extract_fields(relay_state, issue_instant, doc, fields)
    else
      nil
    end
  end
end
