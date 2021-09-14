defmodule Fmcsa do
  @moduledoc """
  Documentation for Fmcsa.
  """

  require Logger

  alias Marshall
  alias Fmcsa.Http

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
    {status, response} = Http.fetch_companies_by_state(state)

    case(status) do
      :error ->
        {:error, response.message}

      :ok ->
        html = response.body

    {:ok, html} = Floki.parse_document(html)

        result = Floki.find(html, "table")

        c = Floki.find(result, "td.MiddleTDFMCSA")

        Marshall.company_names(c)
    end
  end

  def fetch_company_names do
      Enum.map(@states, fn state ->
        {_, companies} = fetch_companies_by_state(state)
        companies
      end)
  end

  def fetch_company_profile(url, acc \\ 0) do

      ## sleep upto 5 seconds so fcma server can calm down and not timeout
    time = :rand.uniform(5000)
    :timer.sleep(time)

    {status, response} = Http.fetch_company_profile(url)
    case response do
     :errconnrefused ->
     if(acc > 5) do
     time = :rand.uniform(5000)
    :timer.sleep(time)
    acc = acc + 1
    fetch_company_profile(url,acc)
    end
    _->
    html = response.body
   {:ok, html} = Floki.parse_document(html)

    main = Floki.find(html, "tr.MiddleTDFMCSA")
    alt = Floki.find(html, "tr.MiddleAltTDFMCSA")

     Marshall.profile({main, alt})
    end
    end

  def fetch_company_profile!(url) do
    {status, response} = Http.fetch_company_profile(url)
    html = response.body
    {:ok, html} = Floki.parse_document(html)
    main = Floki.find(html, "tr.MiddleTDFMCSA")
    alt = Floki.find(html, "tr.MiddleAltTDFMCSA")
    {_, profile} = Marshall.profile({main, alt})
    profile
  end


  def all(state \\ "ALL") do
    response =
      case(state) do
        "SYNC" ->
          companies = Fmcsa.fetch_company_names()
          count = Enum.count(companies)

          Logger.info("Found " <> Integer.to_string(count) <> " companies")

          Enum.map(companies, fn x ->
            {_, url} = x
            Fmcsa.Company.Supervisor.start(x)
            Fmcsa.Company.Server.fetch_profile(x)
          end)

        "ALL" ->
          companies = Fmcsa.fetch_company_names()
          count = Enum.count(companies)

          Logger.info("Found " <> Integer.to_string(count) <> " companies")

          profiles =
            Enum.map(companies, fn x ->
              {_, url} = x
              Fmcsa.fetch_company_profile(url)
            end)

          count = Enum.count(profiles)

          Logger.info("Fetched " <> Integer.to_string(count) <> " profiles")

        _ ->
          {_, response} = Fmcsa.fetch_companies_by_state(state)

          count = Enum.count(response)

          Logger.info("Found " <> Integer.to_string(count) <> " companies")

          profiles =
            Enum.map(response, fn x ->
              {company, url} = x

              Logger.info("Fetching " <> company <> " profile")

              Fmcsa.fetch_company_profile(url)
            end)

          count = Enum.count(profiles)

          Logger.info("Fetched " <> Integer.to_string(count) <> " profiles")
      end

    {:ok, response}
  end
end
