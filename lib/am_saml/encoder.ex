defmodule AmSaml.Encoder do
  def auth_request do
    ~s{
      <samlp:AuthnRequest
        xmlns:samlp="urn:oasis:names:tc:SAML:2.0:protocol"
        xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion"
        ID="#{unique_id()}"
        Version="2.0"
        IssueInstant="#{DateTime.to_iso8601(DateTime.utc_now)}"
        AssertionConsumerServiceIndex="0">
        <saml:Issuer>#{Application.get_env(:am_saml, :saml_issuer)}</saml:Issuer>
        <samlp:NameIDPolicy
          AllowCreate="true"
          Format="urn:oasis:names:tc:SAML:2.0:nameid-format:transient"/>
      </samlp:AuthnRequest>
    }
    |> :zlib.zip # deflation
    |> Base.url_encode64
  end

  defp unique_id, do: :crypto.strong_rand_bytes(16) |> Base.encode64
end
