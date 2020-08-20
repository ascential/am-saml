# AmSaml

## Installation

The package can be installed by adding `am_saml` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:am_saml, git: "git@github.com:ascential/am-saml.git"}]
end
```

## Configuration
Add this to your `/config/dev.exs`:

```elixir
config :am_saml,
  idp_url: "saml_idp_url",
  issuer: "AM_SAML",
  audience: "saml_audience",
  cert: "CERT",
  acs_index: 0,
  force_authn: true
```

To use this in production we recommend using system environment variables like this in your `/config/prod.exs`:

```elixir
config :am_saml,
  idp_url:  System.get_env("SAML_IDP_URL"),
  issuer:   System.get_env("SAML_ISSUER"),
  audience: System.get_env("SAML_AUDIENCE"),
  cert:     System.get_env("SAML_CERT"),
  acs_index: System.get_env("SAML_ACS_INDEX"),
  force_authn: true

```

`acs_index` is optional, default `0`

`force_authn` is optional, default `true`

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

  def init(default), do: default

  def call(conn, _params) do
    case get_session(conn, :auth) do
      nil ->
        conn
        |> Phoenix.Controller.redirect(external: AmSaml.auth_redirect(conn.request_path))
        |> halt
      _ ->
        conn
    end
  end

  def login(conn, saml_info, saml_fields) do
    decoded_response = AmSaml.auth(saml_info, saml_fields)

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

## License

This package is available under the terms of the [BSD-3-Clause](https://opensource.org/licenses/BSD-3-Clause). License can be found in the [LICENSE](LICENSE) file in this directory.