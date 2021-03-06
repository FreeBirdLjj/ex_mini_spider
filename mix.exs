defmodule MiniSpider.MixProject do
  use Mix.Project

  def project do
    [
      app: :mini_spider,
      version: "0.1.0",
      elixir: "~> 1.13",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {MiniSpider.Application, []}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:fake_server, "~> 2.1", only: :test},
      {:finch, "~> 0.11"},
      {:floki, "~> 0.32.0"},
      {:oban, "~> 2.11"}
    ]
  end
end
