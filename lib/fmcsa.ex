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
    [:springgreen, "Fetching companies for " <> state]
    |> Bunt.puts()

    response = HTTPotion.get(@search_url <> state)

    html = response.body

    result = Floki.find(html, "table")

    c = Floki.find(result, "td.MiddleTDFMCSA")

    Marshall.company_names(c)
  end

  def fetch_company_names do
    names =
      Enum.map(@states, fn state ->
        {_, companies} = fetch_companies_by_state(state)
        companies
      end)
  end

  def fetch_company_profile(url) do
    response = HTTPotion.get(@primary_url <> url)
    html = response.body
    main = Floki.find(html, "tr.MiddleTDFMCSA")
    alt = Floki.find(html, "tr.MiddleAltTDFMCSA")
    Marshall.profile({main, alt})
    ## sleep upto 5 seconds so fcma server can calm down and not timeout
    time = :rand.uniform(5000)
    :timer.sleep(time)
  end

  def fetch_company_profile!(url) do
    response = HTTPotion.get(@primary_url <> url)
    html = response.body
    main = Floki.find(html, "tr.MiddleTDFMCSA")
    alt = Floki.find(html, "tr.MiddleAltTDFMCSA")
    {_, profile} = Marshall.profile({main, alt})
    profile
  end

  def fetch_company_profile({company, url}) do
    [:springgreen, "Fetching " <> company <> " profile"]
    |> Bunt.puts()

    response = fetch_company_profile(url)

    case(response) do
      {:ok, data} -> {:ok, {company, data}}
      {:error, data} -> {:error, {company, data}}
    end
  end

  def all(state \\ "ALL") do
    response =
      case(state) do
        "ALL" ->
          companies = Fmcsa.fetch_company_names()
           count = Enum.count companies

          [:springgreen, "Found " <> Integer.to_string(count) <> " companies"]
          |> Bunt.puts()

          profiles = Enum.map(companies, fn x ->
            {_, url} = x
            Fmcsa.fetch_company_profile(url)
          end)

          count = Enum.count profiles

          [:springgreen, "Fetched " <> Integer.to_string(count) <> " profiles"]
          |> Bunt.puts()

        _ ->
          {_, response} = Fmcsa.fetch_companies_by_state(state)

          count = Enum.count response

          [:springgreen, "Found " <> Integer.to_string(count) <> " companies"]
          |> Bunt.puts()

         profiles =  Enum.map(response, fn x ->
            {company, url} = x
            [:springgreen, "Fetching " <> company <> " profile"]
            |> Bunt.puts()
            Fmcsa.fetch_company_profile(url)
          end)

          count = Enum.count profiles

          [:springgreen, "Fetched " <> Integer.to_string(count) <> " profiles"]
          |> Bunt.puts()

          #          Enum.map(response, fn x ->
          #            Fmcsa.Company.Supervisor.start(x)
          #            Fmcsa.Company.Server.show_profile(x)
          #          end)
      end

    {:ok, response}
  end
end
