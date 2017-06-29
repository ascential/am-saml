defmodule AmSamlTest do
  use ExUnit.Case, async: true

  @relay_state "http://redirect/url"

  test "a correct url is generated" do
    result = AmSaml.auth_redirect(@relay_state)
    assert Regex.match?(~r/^saml_idp_url\?SAMLRequest=.*&RelayState=.*$/, result)
  end

  test "the saml authoriser returns the correct structure" do
    relay_state = Base.url_encode64(@relay_state)
    saml_response = Base.encode64(saml_response())
    result = AmSaml.auth(%{"RelayState" => relay_state, "SAMLResponse" => saml_response}, ["foo", "bar"])

    assert result["issue_instant"] == "FOREVER"
    assert result["foo"] == "FOO"
    assert result["bar"] == "BAR"
    assert result["relay_state"] == @relay_state
  end

  defp saml_response do
~S(
<saml2p:Response xmlns:saml2p="urn:oasis:names:tc:SAML:2.0:protocol" Destination="https://2a7bd044.ngrok.io/saml" ID="id167973409945097171696167219" InResponseTo="5eaa39d6-8fd5-41a0-b290-5c4e54833249" IssueInstant="FOREVER" Version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <saml2:Issuer xmlns:saml2="urn:oasis:names:tc:SAML:2.0:assertion" Format="urn:oasis:names:tc:SAML:2.0:nameid-format:entity">http://www.okta.com/exk1mb9ytvvUrhDdf1t7</saml2:Issuer>
    <ds:Signature xmlns:ds="http://www.w3.org/2000/09/xmldsig#">
        <ds:SignedInfo>
            <ds:CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#" />
            <ds:SignatureMethod Algorithm="http://www.w3.org/2001/04/xmldsig-more#rsa-sha256" />
            <ds:Reference URI="#id167973409945097171696167219">
                <ds:Transforms>
                    <ds:Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature" />
                    <ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#">
                        <ec:InclusiveNamespaces xmlns:ec="http://www.w3.org/2001/10/xml-exc-c14n#" PrefixList="xs" />
                    </ds:Transform>
                </ds:Transforms>
                <ds:DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256" />
                <ds:DigestValue>i4xD3bDRY3WZPcWiQLidshYyv7xyv+wdzqGBt++9oZI=</ds:DigestValue>
            </ds:Reference>
        </ds:SignedInfo>
        <ds:SignatureValue>ZlTTqK9m5NWAebp71g1cHok3MkFsGuqvXanMt1HDVf6EPtWdtr6Yk175eNYUrJoCkSWAZVTSBFmZg8naBbG8/IIalLp6bPRENdto90kwwOz3sHJVsTIF1fjVA+RN79z4+dKdKpGXxVsWQW4YhafZAE+/a34O8llkuOdW0l1OJ3Rfq7tTSvV/VgKilDJ1RdW0mYpbF/vM3jl5C1VtQ6w82zqGLqAFx6iBX472QX1yNWLCHB1J1kQq9riS7vJ/H9OjH6D4ruHpLm/8e8lg+FdxY96t4WXKYB7ozu7tZYZKiXd+ddVQ7UajRq/NJP1uuL4OmAkmEpWxGhlBWwZ2dyEgVw==</ds:SignatureValue>
        <ds:KeyInfo>
            <ds:X509Data>
                <ds:X509Certificate>CERT</ds:X509Certificate>
            </ds:X509Data>
        </ds:KeyInfo>
    </ds:Signature>
    <saml2p:Status xmlns:saml2p="urn:oasis:names:tc:SAML:2.0:protocol">
        <saml2p:StatusCode Value="urn:oasis:names:tc:SAML:2.0:status:Success" />
    </saml2p:Status>
    <saml2:Assertion xmlns:saml2="urn:oasis:names:tc:SAML:2.0:assertion" ID="id16797340994534639917674537" IssueInstant="2017-03-12T07:52:51.298Z" Version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema">
        <saml2:Issuer Format="urn:oasis:names:tc:SAML:2.0:nameid-format:entity" xmlns:saml2="urn:oasis:names:tc:SAML:2.0:assertion">http://www.okta.com/exk1mb9ytvvUrhDdf1t7</saml2:Issuer>
        <ds:Signature xmlns:ds="http://www.w3.org/2000/09/xmldsig#">
            <ds:SignedInfo>
                <ds:CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#" />
                <ds:SignatureMethod Algorithm="http://www.w3.org/2001/04/xmldsig-more#rsa-sha256" />
                <ds:Reference URI="#id16797340994534639917674537">
                    <ds:Transforms>
                        <ds:Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature" />
                        <ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#">
                            <ec:InclusiveNamespaces xmlns:ec="http://www.w3.org/2001/10/xml-exc-c14n#" PrefixList="xs" />
                        </ds:Transform>
                    </ds:Transforms>
                    <ds:DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256" />
                    <ds:DigestValue>7QN2QtMouHJsEnfPst18SET4reMkhaUwCJikbwT+mM8=</ds:DigestValue>
                </ds:Reference>
            </ds:SignedInfo>
            <ds:SignatureValue>D9DiYUx21gRz2FZ5TTbiHkqpBb4uJjfIvAA9z2pm3KeEApS3ayizVPzBPE8vMkW4b5KF3mOlYqeAuKwQePj0I/L9pJJSMre9xTGnr6HQlIFnJ2RkLbivun0ntFq/3SNtiN5D1gSF/+QunG3OIdIVRmDMJOmO2dWuFbDf2OQr3cFRERI/Dg1dLLt2+08u6Nig3c+J9tnw/4N0ne/Pfy6Tj3D5NJSoWP/cKXDBZe3mzLcOJtdpIw1K5biDcQANCtxZ+b157mjU5ftAy61X7vpcSRFKA4YbYrNEvkUrUISrGsYR0N6lj+YigRQ+lyRoI9yg98rJkga6Ul86a4ocLvcUmw==</ds:SignatureValue>
            <ds:KeyInfo>
                <ds:X509Data>
                    <ds:X509Certificate>CERT</ds:X509Certificate>
                </ds:X509Data>
            </ds:KeyInfo>
        </ds:Signature>
        <saml2:Subject xmlns:saml2="urn:oasis:names:tc:SAML:2.0:assertion">
            <saml2:NameID Format="urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified">nic.ford@ascential.com</saml2:NameID>
            <saml2:SubjectConfirmation Method="urn:oasis:names:tc:SAML:2.0:cm:bearer">
                <saml2:SubjectConfirmationData InResponseTo="5eaa39d6-8fd5-41a0-b290-5c4e54833249" NotOnOrAfter="2017-03-12T07:57:51.298Z" Recipient="https://2a7bd044.ngrok.io/saml" />
            </saml2:SubjectConfirmation>
        </saml2:Subject>
        <saml2:Conditions NotBefore="2017-03-12T07:47:51.298Z" NotOnOrAfter="2017-03-12T07:57:51.298Z" xmlns:saml2="urn:oasis:names:tc:SAML:2.0:assertion">
            <saml2:AudienceRestriction>
                <saml2:Audience>saml_audience</saml2:Audience>
            </saml2:AudienceRestriction>
        </saml2:Conditions>
        <saml2:AuthnStatement AuthnInstant="2017-03-12T07:52:50.738Z" SessionIndex="5eaa39d6-8fd5-41a0-b290-5c4e54833249" xmlns:saml2="urn:oasis:names:tc:SAML:2.0:assertion">
            <saml2:AuthnContext>
                <saml2:AuthnContextClassRef>urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport</saml2:AuthnContextClassRef>
            </saml2:AuthnContext>
        </saml2:AuthnStatement>
        <saml2:AttributeStatement xmlns:saml2="urn:oasis:names:tc:SAML:2.0:assertion">
            <saml2:Attribute Name="bar" NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:unspecified">
                <saml2:AttributeValue xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="xs:string">BAR</saml2:AttributeValue>
            </saml2:Attribute>
            <saml2:Attribute Name="foo" NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:unspecified">
                <saml2:AttributeValue xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="xs:string">FOO</saml2:AttributeValue>
            </saml2:Attribute>
        </saml2:AttributeStatement>
    </saml2:Assertion>
</saml2p:Response>
)
  end

end
