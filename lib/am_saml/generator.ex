defmodule AmSaml.Generator do
  @moduledoc """
  Generates the resulting map by extracting them from the saml_response.
  """
  import SweetXml

  @doc """
  Generates the map that's being returned from a SAML auth response
  """
  def extract_fields(relay_state, issue_instant, doc, optFields) do
    Enum.reduce(
      optFields,
      %{
        "relay_state" => Base.url_decode64!(relay_state),
        "issue_instant" => issue_instant
      },
      fn x, a -> extract_field(x, a, doc) end
    )
  end

  defp extract_field(key, acc, doc) do
    %{x: extracted} = doc |> xmap(
      x: ~x{//saml2:Attribute[@Name="#{key}"]/saml2:AttributeValue/text()}s
          |> add_namespace("saml2", "urn:oasis:names:tc:SAML:2.0:assertion")
    )
    Map.put(acc, key, extracted)
  end
end
