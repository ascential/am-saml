defmodule AmSaml.Encoder do
  @moduledoc """
  Encodes the authentication request to the SAML provider.
  """

  @doc """
  Encodes the auth request that will be send to the SAML provider
  """
  def auth_request(saml_issuer) do
    ~s{
      <samlp:AuthnRequest
        xmlns:samlp="urn:oasis:names:tc:SAML:2.0:protocol"
        xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion"
        ID="#{unique_id()}"
        Version="2.0"
        ForceAuthn="#{force_authn()}"
        IssueInstant="#{issue_instant()}"
        AssertionConsumerServiceIndex="#{acs_index()}">
        <saml:Issuer>
          #{saml_issuer}
        </saml:Issuer>
        <samlp:NameIDPolicy
          AllowCreate="true"
          Format="urn:oasis:names:tc:SAML:2.0:nameid-format:transient"/>
      </samlp:AuthnRequest>
    }
    |> :zlib.zip # deflation
    |> Base.url_encode64
  end

  defp unique_id, do: Base.encode64(:crypto.strong_rand_bytes(16))

  defp issue_instant, do: DateTime.to_iso8601(DateTime.utc_now)

  defp acs_index do
    case Application.get_env(:am_saml, :acs_index) do
      idx when is_integer(idx) -> idx
      idx when is_binary(idx) ->
        case Integer.parse(idx) do
          {idx, _} when is_integer(idx) -> idx
          _ -> 0
        end
      _ -> 0
    end
  end

  defp force_authn do
    case Application.get_env(:am_saml, :force_authn) do
      false -> false
      _ -> true
    end
  end
end
