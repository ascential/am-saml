# AmSaml

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `am_saml` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:am_saml, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/am_saml](https://hexdocs.pm/am_saml).

## Configuration
Add this to your /config/dev.exs:

```elixir
config :am_saml,
  saml_idp_url: "saml_idp_url",
  saml_issuer: "AM_SAML",
  saml_audience: "saml_audience",
  saml_cert: "CERT"
```

To use this in production we recommend using system environment variables like this in your /config/prod.exs:

```elixir
config :am_saml,
  saml_idp_url:  System.get_env("SAML_IDP_URL"),
  saml_issuer:   System.get_env("SAML_ISSUER"),
  saml_audience: System.get_env("SAML_AUDIENCE"),
  saml_cert:     System.get_env("SAML_CERT")
```

## Docs
To generate docs run:

```bash
mix docs
```
