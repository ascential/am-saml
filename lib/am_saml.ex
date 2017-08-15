defmodule AmSaml do
  @moduledoc """
  Provides auth-related functions.
  """
  alias AmSaml.{Decoder, Encoder, Generator, Validator}

  @doc """
  Provides the redirect url to the saml_provider
  """
  def auth_redirect(%{"saml_idp_url" => saml_idp_url, "saml_issuer" => saml_issuer}, relay_state) do
    ~s{#{saml_idp_url}?SAMLRequest=#{Encoder.auth_request(saml_issuer)}&RelayState=#{Base.url_encode64(relay_state)}}
  end

  @doc """
  Handles the authentication from the saml_response and fields user provides

  Returns a map with fields provided in it, note that should exist in order to fetch them from the saml response.

  ## Example

      iex> AmSaml.auth(%{"RelayState" => "http://yoursite.com/existing_url/", "SAMLResponse" => "saml_response"}, ["foo", "bar"])
      %{"RelayState" => "http://yoursite.com/existing_url/", "SAMLResponse" => "saml_response", "foo" => "foo", "bar" => "bar"}

  """
  def auth(%{"RelayState" => relay_state, "SAMLResponse" => saml_response}, samlFields, %{"saml_cert" => saml_cert, "saml_audience" => saml_audience}) do
    %{c: cert, a: audience, i: issue_instant, d: doc} = Decoder.saml_response(saml_response)

    if Validator.valid_cert?(cert, saml_cert) && Validator.valid_audience?(audience, saml_audience) do
      Generator.saml_response(relay_state, issue_instant, doc, samlFields)
    else
      nil
    end
  end
end
