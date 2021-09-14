defmodule Fmcsa.Http do
  @moduledoc false
  use Tesla

  require Logger

  @primary_url "https://ai.fmcsa.dot.gov/hhg"
  @search_url "/SearchResults.asp?lan=EN&search=5&ads=a&state="

  plug(Tesla.Middleware.BaseUrl, @primary_url)

  def fetch_companies_by_state(state) do
    Logger.info("Fetching companies for " <> state)
    get(@search_url <> state)
  end

  def fetch_company_profile(data) do
    Logger.info("Fetching company profile: " <> data)
    get("/#{data}")
  end
end
