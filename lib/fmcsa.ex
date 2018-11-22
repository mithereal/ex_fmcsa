defmodule Fmcsa do
  @moduledoc """
  Documentation for Fmcsa.
  """

 @search_url "https://ai.fmcsa.dot.gov/hhg/SearchResults.asp?lan=EN&search=5&ads=a&state="
 
 @states  ["AK", "AL", "AR", "AZ", "CA", "CO", "CT", "DE", "FL", "GA", "HI", "IA", "ID", "IL", "IN", "KS", "KY", "LA", "MA", "MD", "ME", "MI", "MN", "MO", "MS", "MT", "NC", "ND", "NE", "NH", "NJ", "NM", "NV", "NY", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VA", "VT", "WA", "WI", "WV", "WY"]
 
 def fetch_companies_by_state(state) do
 response = HTTPotion.get(@search_url <> state)

 html = response.body

 [result] = Floki.find(html, "table")

 {_, _, table} = result

 [result] = Floki.find(table, "tr.MiddleTDFMCSA")

 {_, _, tr} = result
 
 result = Floki.find(tr, "tr:nth-child(1)")
 
 
 
 end
 
 def fetch_company_names do
 names = Enum.map(@states, fn(state) ->
 fetch_companies_by_state(state)
 end)
 end
 
end
