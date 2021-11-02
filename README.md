# Ueberauth OpenAM Strategy

[![Build](https://github.com/nulib/ueberauth_openam/actions/workflows/build.yml/badge.svg)](https://github.com/nulib/ueberauth_openam/actions/workflows/build.yml)
[![Coverage](https://coveralls.io/repos/github/nulib/ueberauth_openam/badge.svg?branch=master)](https://coveralls.io/github/nulib/ueberauth_openam?branch=master)
[![Documentation](http://inch-ci.org/github/nulib/ueberauth_openam.svg?branch=master)](http://inch-ci.org/github/nulib/ueberauth_openam)
[![Hex.pm](https://img.shields.io/hexpm/v/ueberauth_openam.svg)](https://hex.pm/packages/ueberauth_openam)

[OpenAM](https://github.com/OpenIdentityPlatform/OpenAM) strategy for [Ueberauth](https://github.com/ueberauth/ueberauth)

## Installation

1. Add `ueberauth` and `ueberauth_openam` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ueberauth, "~> 0.2"},
    {:ueberauth_openam, "~> 0.1.0"},
  ]
end
```

2. Ensure `ueberauth_openam` is started before your application:

```elixir
def application do
  [applications: [:ueberauth_openam]]
end
```

3. Configure the OpenAM integration in `config/config.exs`:

```elixir
config :ueberauth, Ueberauth,
  providers: [openam: {Ueberauth.Strategy.OpenAM, [
    base_url: "http://websso.example.com/",
    sso_cookie: "openAMssoToken",
  ]}]
```

4. Add the request and callback routes in your router (below are defaults):

```
get "/:provider", AuthController, :request
get "/:provider/callback", AuthController, :callback
```

5. In your auth controller include the Üeberauth plug and implement the callback routes for success and failure:

```elixir
defmodule MyApp.AuthController do
  use MyApp.Web, :controller

  plug Ueberauth


  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    ...
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    ...
  end
end
```

## Contributing

Issues and Pull Requests are always welcome!
