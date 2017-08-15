defmodule AmSaml.Validator do
  @moduledoc """
  Provides validator functions for audience and certificate.
  """

  @doc """
  Compares the certificate from the SAMLResponse with the certificate expected in env variables
  """
  def valid_cert?(cert, cert), do: true
  def valid_cert?(user_cert, saml_cert), do: false

  @doc """
  Compares the audience from the SAMLResponse with the audience expected in env variables
  """
  def valid_audience?(aud, aud), do: true
  def valid_audience?(aud, saml_aud), do: false
end
