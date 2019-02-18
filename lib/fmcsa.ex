defmodule Fmcsa do
  @moduledoc """
  Documentation for Fmcsa.
  """

  alias Marshall

  @primary_url "https://ai.fmcsa.dot.gov/hhg/"

  @search_url "https://ai.fmcsa.dot.gov/hhg/SearchResults.asp?lan=EN&search=5&ads=a&state="

  @states [
    "AK",
    "AL",
    "AR",
    "AZ",
    "CA",
    "CO",
    "CT",
    "DE",
    "FL",
    "GA",
    "HI",
    "IA",
    "ID",
    "IL",
    "IN",
    "KS",
    "KY",
    "LA",
    "MA",
    "MD",
    "ME",
    "MI",
    "MN",
    "MO",
    "MS",
    "MT",
    "NC",
    "ND",
    "NE",
    "NH",
    "NJ",
    "NM",
    "NV",
    "NY",
    "OH",
    "OK",
    "OR",
    "PA",
    "RI",
    "SC",
    "SD",
    "TN",
    "TX",
    "UT",
    "VA",
    "VT",
    "WA",
    "WI",
    "WV",
    "WY"
  ]

  def fetch_companies_by_state(state) do
    response = HTTPotion.get(@search_url <> state)

    html = response.body

    result = Floki.find(html, "table")

    c = Floki.find(result, "td.MiddleTDFMCSA")

    companies = Marshall.companies(c)
  end

  def fetch_company_names do
    names =
      Enum.map(@states, fn state ->
        fetch_companies_by_state(state)
      end)
  end

  def fetch_company_profile(url) do
    response = HTTPotion.get(@primary_url <> url)
    html = response.body
    main = Floki.find(html, "tr.MiddleTDFMCSA")
    alt = Floki.find(html, "tr.MiddleAltTDFMCSA")
    profile = Marshall.profile({main, alt})
    #  IO.inspect  profile
  end

  def fetch_company_profile({company, url}) do
    response = fetch_company_profile(url)

    case(response) do
      {:ok, data} -> {:ok, {company, data}}
      {:error, data} -> {:error, {company, data}}
    end
  end
end
