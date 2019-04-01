defmodule UeberauthOpenam.MixProject do
  use Mix.Project

  @version "0.2.0"
  @url     "https://github.com/nulib/ueberauth_openam"

  def project do
    [
      app: :ueberauth_openam,
      version: @version,
      elixir: "~> 1.2",
      name: "Ueberauth OpenAM strategy",
      package: package(),
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env() == :prod,
      source_url: @url,
      homepage_url: @url,
      deps: deps(),
      preferred_cli_env: [
        coveralls: :test, 
        "coveralls.detail": :test, 
        "coveralls.post": :test, 
        "coveralls.html": :test, 
        espec: :test
      ],
      test_coverage: [tool: ExCoveralls, test_task: "espec"]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:logger, :ueberauth, :httpoison]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ueberauth, "~> 0.2"},
      {:httpoison, "~> 0.11"},
      {:espec, "~> 1.7.0", only: :test},
      {:excoveralls, "~> 0.5", only: :test},
      {:inch_ex, "~> 0.5.0", only: [:dev, :docs, :test]},
      {:earmark, "~> 1.2", only: [:dev, :docs, :test]},
      {:ex_doc, "~> 0.19", only: [:dev, :docs, :test]},
     ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE.md"],
      maintainers: ["Michael B. Klein"],
      licenses: ["MIT"],
      links: %{"GitHub": @url}
    ]
  end
end
