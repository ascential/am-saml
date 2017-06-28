defmodule AmSaml do
  import SweetXml

  def init(default), do: default

  def auth_redirect(relay_state) do
    auth_request = ~s{
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

    ~s{#{Application.get_env(:am_saml, :saml_idp_url)}?SAMLRequest=#{auth_request}&RelayState=#{Base.url_encode64(relay_state)}}
  end

  def auth(%{"RelayState" => relay_state, "SAMLResponse" => saml_response}, samlFields) do
    {:ok, saml_response} = Base.decode64(saml_response)

    doc = parse(saml_response, namespace_conformant: true)
    %{c: cert, a: audience, i: issue_instant} = doc |> xmap(
      c: ~x{//saml2:Assertion//ds:X509Certificate/text()}s
          |> add_namespace("saml2", "urn:oasis:names:tc:SAML:2.0:assertion")
          |> add_namespace("ds", "http://www.w3.org/2000/09/xmldsig#"),

      a: ~x{//saml2:Assertion//saml2:AudienceRestriction/saml2:Audience/text()}s
          |> add_namespace("saml2", "urn:oasis:names:tc:SAML:2.0:assertion"),

      i: ~x{//saml2p:Response/@IssueInstant}s
          |> add_namespace("saml2p", "urn:oasis:names:tc:SAML:2.0:protocol")
    )

    required_cert = Application.get_env(:am_saml, :saml_cert) |> String.replace("\\n", "\n")
    required_audience = Application.get_env(:am_saml, :saml_audience)

    if cert == required_cert && audience == required_audience do
      Map.merge(%{
        "relay_state" => relay_state |> Base.url_decode64!,
        "issue_instant" => issue_instant
      }, Enum.reduce(samlFields, %{}, fn(x, a) -> add_saml_field(x, a, doc) end))
    else
      nil
    end
  end

  defp add_saml_field(key, acc, doc) do
    %{x: extracted} = doc |> xmap(
      x: ~x{//saml2:Attribute[@Name="#{key}"]/saml2:AttributeValue/text()}s
          |> add_namespace("saml2", "urn:oasis:names:tc:SAML:2.0:assertion"),
    )
    Map.put(acc, key, extracted)
  end

  defp unique_id, do: :crypto.strong_rand_bytes(16) |> Base.encode64
end
