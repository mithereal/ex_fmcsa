# Fmcsa

Web scraper for fmcsa.dot.gov.
-
######Federal Motor Carrier Safety Administration
This Tool Was Created To Fetch Public Information Related To Registered Motor Carriers In The United States 

## Installation


iex:> {_,response }= Fmcsa.fetch_companies_by_state("AZ")
iex:> {company, url} = List.first(response)

iex:> url |> Fmcsa.fetch_company_profile()

{:ok, %{...}} 


daily sync can be done via:

iex:> Fmcsa.all("SYNC")
{:ok, %{...}}

synced data can be dumped:

iex:> {_,response }= Fmcsa.fetch_companies_by_state("AZ")
iex:> company_response = List.first(response)
iex:> Fmcsa.Company.Server.show_profile(company_response)
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

