defmodule AmSaml.Generator do
  @moduledoc """
  Generates the resulting map by extracting them from the saml_response.
  """
  import SweetXml

  @doc """
  Generates the map that's being returned from a SAML auth response
  """
  def saml_response(relay_state, issue_instant, doc, optFields) do
    Map.merge(
      %{
        "relay_state" => relay_state |> Base.url_decode64!,
        "issue_instant" => issue_instant
        },
        Enum.reduce(
          optFields, %{},
          fn(x, a) ->
            extract_opt_fields(x, a, doc)
          end
        )
      )
    end

  defp extract_opt_fields(key, acc, doc) do
    %{x: extracted} = doc |> xmap(
      x: ~x{//saml2:Attribute[@Name="#{key}"]/saml2:AttributeValue/text()}s
          |> add_namespace("saml2", "urn:oasis:names:tc:SAML:2.0:assertion"),
    )
    Map.put(acc, key, extracted)
  end
end
