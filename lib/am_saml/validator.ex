defmodule AmSaml.Validator do
  @moduledoc """
  Provides validator functions for audience and certificate.
  """

  @doc """
  Compares the certificate from the SAMLResponse with the certificate expected in env variables
  """
  def valid_cert?(user_cert, saml_cert) do
    equal?(
      String.replace(user_cert, "\n", ""),
      String.replace(saml_cert, "\n", "")
    )
  end

  @doc """
  Compares the audience from the SAMLResponse with the audience expected in env variables
  """
  def valid_audience?(user_aud, saml_aud), do: equal?(user_aud, saml_aud)

  defp equal?(a, a), do: true
  defp equal?(_a, _not_a), do: false
end
