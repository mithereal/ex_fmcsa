# Fmcsa


[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/fmcsa/)
[![Hex.pm](https://img.shields.io/hexpm/dt/fmcsa.svg)](https://hex.pm/packages/fmcsa)
[![License](https://img.shields.io/hexpm/l/fmcsa.svg)](https://github.com/mithereal/ex_fmcsa/blob/master/LICENSE)
[![Last Updated](https://img.shields.io/github/last-commit/mithereal/ex_fmcsa.svg)](https://github.com/mithereal/ex_fmcsa/commits/master)

Web scraper for fmcsa.dot.gov.
-

This Tool Was Created To Fetch Public Information Related To Registered Motor Carriers In The United States from the Federal Motor Carrier Safety Administration

## Installation


If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `fmcsa` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:fmcsa, "~> 1.0.0"}
  ]
end
```

## Usage

```elixir
iex:> {_,response }= Fmcsa.fetch_companies_by_state("AZ")
iex:> {company, url} = List.first(response)

iex:> url |> Fmcsa.fetch_company_profile()

{:ok, %{...}} 
```

daily sync can be done via:

```elixir
iex:> Fmcsa.all("SYNC")
{:ok, %{...}}
```

synced data can be dumped:

```elixir
iex:> {_,response }= Fmcsa.fetch_companies_by_state("AZ")
iex:> company_response = List.first(response)
iex:> Fmcsa.Company.Server.show_profile(company_response)
{:ok, %{...}}
```


Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/fmcsa](https://hexdocs.pm/fmcsa).

