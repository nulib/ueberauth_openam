use Mix.Config

config :ueberauth, Ueberauth,
  providers: [
    openam:
      {Ueberauth.Strategy.OpenAM,
       [
         base_url: "https://websso.it.northwestern.edu/amserver/",
         sso_cookie: "openAMssoToken"
       ]}
  ]
