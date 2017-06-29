defmodule AmSaml do
  alias AmSaml.{ Decoder, Encoder, Generator, Validator }

  def init(default), do: default

  def auth_redirect(relay_state) do
    ~s{#{Application.get_env(:am_saml, :saml_idp_url)}?SAMLRequest=#{Encoder.auth_request}&RelayState=#{Base.url_encode64(relay_state)}}
  end

  def auth(%{"RelayState" => relay_state, "SAMLResponse" => saml_response}, samlFields) do
    %{c: cert, a: audience, i: issue_instant, d: doc} = Decoder.saml_response(saml_response)

    if Validator.valid_cert?(cert) && Validator.valid_audience?(audience) do
      Generator.saml_response(relay_state, issue_instant, doc, samlFields)
    else
      nil
    end
  end
end
