use Mix.Config

config :ueberauth, Ueberauth,
  providers: [
    openam: {Ueberauth.Strategy.OpenAM, [base_url: "https://openam.example.edu/", sso_cookie: "openAMssoToken"]}
  ]