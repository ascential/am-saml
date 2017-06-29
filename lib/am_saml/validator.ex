defmodule AmSaml.Validator do
  @moduledoc """
  Provides validator functions for audience and certificate.
  """

  @doc """
  Compares the certificate from the SAMLResponse with the certificate expected in env variables
  """
  def valid_cert?(cert), do: cert == Application.get_env(:am_saml, :saml_cert)

  @doc """
  Compares the audience from the SAMLResponse with the audience expected in env variables
  """
  def valid_audience?(audience), do: audience == Application.get_env(:am_saml, :saml_audience)
end
