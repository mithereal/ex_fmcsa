defmodule Fmcsa.MixProject do
  use Mix.Project

  def project do
    [
      app: :fmcsa,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      build_embedded: Mix.env() == :prod,
      description: description(),
      package: package(),
      elixir: "~> 1.0",
      name: "fmcsa",
      source_url: "https://github.com/mithereal/elixir-fcmsa"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Fmcsa.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      {:floki, "~> 0.20.0"},
      {:httpotion, "~> 3.1.0"},
      {:bunt, "~> 0.2.0"},
      {:ex_doc, "~> 0.14", only: :dev}
    ]
  end

  defp description() do
    "Web scraper for fmcsa.dot.gov."
  end

  defp package() do
    [
      name: "fmcsa",
      files: ["lib", "mix.exs", "README*"],
      maintainers: ["Jason Clark"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/mithereal/elixir-fcmsa"}
    ]
  end
end
