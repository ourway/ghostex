defmodule Ghostex.MixProject do
  use Mix.Project

  def project do
    [
      app: :ghostex,
      version: "0.1.1",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "Ghostex is Ghost blog client library for Elixir",
      source_url: "https://github.com/ourway/ghostex",
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      package: package()
    ]
  end

  defp package do
    # These are the default files included in the package
    [
      name: :ghostex,
      files: ["lib", "mix.exs", "README*", "test"],
      maintainers: ["Farsheed Ashouri"],
      licenses: ["MIT License"],
      links: %{"GitHub" => "https://github.com/ourway/ghostex"}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Ghostex.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:joken, "~> 2.0"},
      {:jason, ">= 0.0.0"},
      {:httpoison, "~> 1.5"},
      {:gen_smtp, "~> 0.13"},
      {:credo, "~> 1.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.6", only: [:dev], runtime: false},
      {:excoveralls, "~> 0.10", only: :test},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end
end
