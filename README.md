# Ueberauth OpenAM Strategy

[![Build](https://circleci.com/gh/nulib/ueberauth_openam.svg?style=svg)](https://circleci.com/gh/nulib/ueberauth_openam)
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

  4. In `AuthController` use the OpenAM strategy in your `login/4` function:

```elixir
def login(conn, _params, _current_user, _claims) do
  conn
  |> Ueberauth.Strategy.OpenAM.handle_request!
end
```

## Contributing

Issues and Pull Requests are always welcome!
