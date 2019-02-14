defmodule Fmcsa do
  @moduledoc """
  Documentation for Fmcsa.
  """

 @primary_url "https://ai.fmcsa.dot.gov/hhg/"

 @search_url "https://ai.fmcsa.dot.gov/hhg/SearchResults.asp?lan=EN&search=5&ads=a&state="

 @states  ["AK", "AL", "AR", "AZ", "CA", "CO", "CT", "DE", "FL", "GA", "HI", "IA", "ID", "IL", "IN", "KS", "KY", "LA", "MA", "MD", "ME", "MI", "MN", "MO", "MS", "MT", "NC", "ND", "NE", "NH", "NJ", "NM", "NV", "NY", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VA", "VT", "WA", "WI", "WV", "WY"]

 def fetch_companies_by_state(state) do
 response = HTTPotion.get(@search_url <> state)

 html = response.body

 result = Floki.find(html, "table")

 c = Floki.find(result, "td.MiddleTDFMCSA")

 companies = Enum.map(c, fn x ->
 name = case(x)do
   {_,_,[{_,[{_,url}],[name]},_]} -> {name, url}
   {_, _, [city_state]} -> nil

 end
                      name
                       end)

Enum.reject(companies, &is_nil/1)

 end

 def fetch_company_names do
 names = Enum.map(@states, fn(state) ->
 fetch_companies_by_state(state)
 end)
 end

 def fetch_company_profile(url) do
    response = HTTPotion.get(@primary_url <> url)
    html = response.body
    result = Floki.find(html, "tr.MiddleAltTDFMCSA")

                                                  [  {_, _,    [      _,      _,      {_, _,[name]}    ]},  {_, _,    [     _,      _,      {_, _, [mc]}    ]},  {_, _,    [      _,     _,      {_, _, [ma]}    ]},  _,    [     _,      _,      {_, _, [fax]}    ]},  {_, _,    [      _,      _,      {_, _,        [{_, _, [rating]}]}    ]},  {_, _, _},  {_},  {_, _,    [      _      _,      {_, _, [numberoftrucks]}    ]},  {_, _,    [      _,      _,      {_, _, [numberoftrucks]}    ]}]
                                                  = result
    IO.inspect(result)
 end

end
