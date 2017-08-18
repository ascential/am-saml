defmodule AmSaml do
  @moduledoc """
  Provides auth-related functions.
  """
  alias AmSaml.{Decoder, Encoder, Generator, Validator}
  require Logger

  @doc """
  Provides the redirect url to the saml_provider
  """
  def auth_redirect([idp_url, issuer], relay_state) do
    relay = if relay_state == "", do: "/", else: relay_state
    ~s{#{idp_url}?SAMLRequest=#{Encoder.auth_request(issuer)}&RelayState=#{Base.url_encode64(relay)}}
  end

  @doc """
  Handles the authentication from the saml_response and fields user provides

  Returns a map with fields provided in it, note that should exist in order to fetch them from the saml response.

  ## Example

      iex> AmSaml.auth(%{"RelayState" => "http://yoursite.com/existing_url/", "SAMLResponse" => "saml_response"}, ["foo", "bar"])
      %{"RelayState" => "http://yoursite.com/existing_url/", "SAMLResponse" => "saml_response", "foo" => "foo", "bar" => "bar"}

  """
  def auth(%{"RelayState" => relay_state, "SAMLResponse" => saml_response}, samlFields, [saml_cert, saml_audience]) do
    %{c: cert, a: audience, i: issue_instant, d: doc} = Decoder.saml_response(saml_response)
    Logger.info(fn -> "Cert:" <> inspect(cert) end )
    Logger.info(fn -> "SAML Cert:" <> inspect(saml_cert) end )
    Logger.info(fn -> "Audience:" <> inspect(audience) end )
    Logger.info(fn -> "SAML Audience:" <> inspect(saml_audience) end )

    if Validator.valid_cert?(cert, saml_cert) && Validator.valid_audience?(audience, saml_audience) do
      Generator.saml_response(relay_state, issue_instant, doc, samlFields)
    else
      nil
    end
  end
end
