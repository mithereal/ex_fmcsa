# Fmcsa

Web scraper for fmcsa.dot.gov.
-
######Federal Motor Carrier Safety Administration
this tool was created to fetch public information related to registered motor carriers in the united states 

## Installation



ex. iex:> response = Fmcsa.Fmcsa.fetch_companies_by_state("AZ")
company = List.first(response)

company
|> Fmcsa.fetch_company_profile()

{:ok, %{...}} 


If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `fmcsa` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:fmcsa, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/fmcsa](https://hexdocs.pm/fmcsa).

