defmodule AmSaml.Validator do
  @moduledoc """
  Provides validator functions for audience and certificate.
  """

  @doc """
  Compares the certificate from the SAMLResponse with the certificate expected in env variables
  """
  def valid_cert?(user_cert, saml_cert) do
    x = user_cert |> String.trim |> String.replace("\n", "")
    y = saml_cert |> String.trim |> String.replace("\n", "")
    x == y
  end

  @doc """
  Compares the audience from the SAMLResponse with the audience expected in env variables
  """
  def valid_audience?(aud, aud), do: true
  def valid_audience?(aud, saml_aud), do: false
end
