defmodule AmSaml.Decoder do
  import SweetXml

  def saml_response(saml_response) do
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

    %{c: cert, a: audience, i: issue_instant, d: doc}
  end
end
