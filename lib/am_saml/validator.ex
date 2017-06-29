defmodule AmSaml.Validator do
  def valid_cert?(cert), do: cert == Application.get_env(:am_saml, :saml_cert)
  def valid_audience?(audience), do: audience == Application.get_env(:am_saml, :saml_audience)
end
