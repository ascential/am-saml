# AmSaml

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `am_saml` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:am_saml, "~> 0.2.0"}]
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

## Phoenix example usage

The package is abstract which enables you to easily integrate SAML authentication whilst keeping full control over your phoenix application.

To illustrate this i'll share an example implementation:

```elixir
# /web/controller/session_controller.ex

defmodule ExampleApp.SessionController do
  use ExampleApp.Web, :controller

  alias ExampleApp.Plug.Auth

  def create(conn, params) do
    conn
    |> put_flash(:info, "You're now logged in!")
    |> Auth.login(params, ["first_name", "last_name"])
  end

  def delete(conn, _) do
    conn
    |> put_flash(:info, "Successfully logged out")
    |> Auth.logout
    |> redirect(to: "/")
  end
end
```

```elixir
# /lib/example_app/plugs/auth.ex

defmodule ExampleApp.Plug.Auth do
  import Plug.Conn
  import AmSaml

  def init(default), do: default

  def call(conn, _params) do
    case get_session(conn, :auth) do
      nil ->
        conn
        |> Phoenix.Controller.redirect(external: auth_redirect(conn.request_path))
        |> halt
      _ ->
        conn
    end
  end

  def login(conn, samlInfo, samlFields) do
    decoded_response = auth(samlInfo, samlFields)

    case decoded_response do
      nil ->
        conn
        |> Phoenix.Controller.redirect(to: "/")
      _ ->
        conn
        |> put_session(:auth, decoded_response)
        |> Phoenix.Controller.redirect(to: decoded_response["RelayState"] || "/")
    end
  end

  def logout(conn) do
    conn
    |> delete_session(:auth)
  end
end
```

```elixir
# /web/router.ex

pipeline :with_session do
  plug ExampleApp.Plug.Auth
end

scope "/", ExampleApp do
  pipe_through [:browser, :with_session]

  get "/logout", SessionController, :delete
end

scope "/", ExampleApp do
  pipe_through [:saml]
  resources "/session", SessionController, only: [:create]
end
```

## Docs
To generate docs run:

```bash
mix docs
```

## Todo
* Add more authentication strategies
* Improve code
