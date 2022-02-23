defmodule UeberauthOpenam.MixProject do
  use Mix.Project

  @version "1.0.0"
  @url "https://github.com/nulib/ueberauth_openam"

  def project do
    [
      app: :ueberauth_openam,
      version: @version,
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      name: "Ueberauth OpenAM strategy",
      description: "OpenAM strategy for use with Ueberauth",
      package: package(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      source_url: @url,
      homepage_url: @url,
      deps: deps(),
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      test_coverage: [tool: ExCoveralls]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:logger, :ueberauth, :httpoison]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:earmark, "~> 1.2", only: :docs},
      {:ex_doc, "~> 0.19", only: :docs},
      {:excoveralls, "~> 0.5", only: :test},
      {:httpoison, "~> 1.0"},
      {:mox, "~> 1.0"},
      {:ueberauth, "~> 0.2"}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE.md"],
      maintainers: ["Michael B. Klein"],
      licenses: ["Apache-2.0"],
      links: %{GitHub: @url}
    ]
  end
end
