defmodule Fmcsa.MixProject do
  use Mix.Project

  @source_url "https://github.com/mithereal/ex_fmcsa.git"
  @version "1.1.0"

  def project do
    [
      app: :fmcsa,
      version: @version,
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      build_embedded: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      docs: docs(),
      name: "fmcsa",
      source_url: @source_url
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
      {:floki, "~> 0.31.0"},
      {:tesla, "~> 1.4"},
      {:hackney, "~> 1.17"},
      {:telemetry, "~> 0.4.0"},
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
      links: %{"GitHub" => "https://github.com/mithereal/ex_fmcsa"}
    ]
  end

  defp docs() do
    [
      main: "readme",
      name: "fmcsa",
      source_ref: "v#{@version}",
      canonical: "http://hexdocs.pm/fmcsa",
      source_url: @source_url,
      extras: ["README.md"]
    ]
  end
end
