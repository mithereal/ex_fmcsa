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
    result = Floki.find(html, "tr.MiddleTDFMCSA")
    result2 = Floki.find(html, "tr.MiddleAltTDFMCSA")

    [
      {"tr", [{"class", "MiddleTDFMCSA"}],
        [
          {"td", [{"style", "white-space:nowrap"}], ["USDOT Number"]},
          {"td", [], [":"]},
          {"td", [{"nowrap", "nowrap"}, {"width", "98%"}], [usdot_number]}
        ]},
      {"tr", [{"class", "MiddleTDFMCSA"}],
        [
          {"td", [{"style", "white-space:nowrap"}, {"valign", "top"}], ["Address"]},
          {"td", [], [":"]},
          {"td", [{"width", "98%"}],
            [
              address,
              {"br", [], []},
              city_state_zip
            ]}
        ]},
      {"tr", [{"class", "MiddleTDFMCSA"}],
        [
          {"td", [{"style", "white-space:nowrap"}, {"valign", "top"}], ["Telephone"]},
          {"td", [], [":"]},
          {"td", [{"width", "98%"}], [phone_number]}
        ]},
      {"tr", [{"class", "MiddleTDFMCSA"}],
        [
          {"td", [{"width", "1%"}, {"style", "white-space:nowrap"}], ["Review Date"]},
          {"td", [], [":"]},
          {"td", [{"nowrap", "nowrap"}], [review_date]}
        ]},
      {"tr", [{"class", "MiddleTDFMCSA"}],
        [
          {"td", [{"width", "1%"}, {"style", "white-space:nowrap"}],
            ["Licensing & Insurance Status"]},
          {"td", [], [":"]},
          {"td", [{"nowrap", "nowrap"}],
            [
              {"a",
                [
                  {"href",
                    insurance_data_url},
                  {"target", "_blank"}
                ], ["Insurance Data"]}
            ]}
        ]},
      {"tr", [{"class", "MiddleTDFMCSA"}],
        [
          {"td", [{"width", "1%"}, {"style", "white-space:nowrap"}],
            ["Number of Tractors"]},
          {"td", [{"width", "1%"}], [":"]},
          {"td", [], [number_of_tractors]}
        ]}
    ] = result

    [
      {"tr", [{"class", "MiddleAltTDFMCSA"}],
        [
          {"td", [{"style", "white-space:nowrap"}], ["Name"]},
          {"td", [], [":"]},
          {"td", [{"style", "white-space:wrap"}, {"width", "98%"}],
            [name]}
        ]},
      {"tr", [{"class", "MiddleAltTDFMCSA"}],
        [
          {"td", [{"style", "white-space:nowrap"}], ["MC #"]},
          {"td", [], [":"]},
          {"td", [{"nowrap", "nowrap"}, {"width", "98%"}], [motor_carrage_number]}
        ]},
      {"tr", [{"class", "MiddleAltTDFMCSA"}],
        [
          {"td", [{"style", "white-space:nowrap"}], ["Mailing Address"]},
          {"td", [], [":"]},
          {"td", [{"nowrap", "nowrap"}, {"valign", "top"}, {"width", "98%"}],
            [
              mailing_address,
              {"br", [], []},
              mailing_address_city_state_zip
            ]}
        ]},
      {"tr", [{"class", "MiddleAltTDFMCSA"}],
        [
          {"td", [{"style", "white-space:nowrap"}], ["Fax"]},
          {"td", [], [":"]},
          {"td", [{"width", "98%"}], [fax_number]}
        ]},
      {"tr", [{"class", "MiddleAltTDFMCSA"}],
        [
          {"td", [{"width", "1%"}, {"style", "white-space:nowrap"}],
            ["Safety Rating"]},
          {"td", [], [":"]},
          {"td", [{"nowrap", "nowrap"}],
            [{"span", [{"class", "b"}], [safety_rating]}]}
        ]},
      {"tr", [{"class", "MiddleAltTDFMCSA"}],
        [
          {"td", [{"style", "white-space:nowrap"}, {"colspan", "3"}],
            [
              "Most recent ",
              {"a",
                [
                  {"href",
                    safety_rating_url},
                  {"target", "_blank"}
                ], ["Safety Rating Data"]}
            ]}
        ]},
      {"tr", [{"class", "MiddleAltTDFMCSA"}],
        [{"td", [{"style", "white-space:nowrap"}, {"colspan", "3"}], []}]},
      {"tr", [{"class", "MiddleAltTDFMCSA"}],
        [
          {"td", [{"width", "1%"}, {"style", "white-space:nowrap"}],
            [_]},
          {"td", [{"width", "1%"}], [":"]},
          {"td", [], [number_of_trucks]}
        ]},
      {"tr", [{"class", "MiddleAltTDFMCSA"}],
        [
          {"td", [{"width", "1%"}, {"style", "white-space:nowrap"}],
            [_]},
          {"td", [{"width", "1%"}], [":"]},
          {"td", [], [number_of_trailers]}
        ]}
    ] = result2

 %{
"name" => name,
"usdot_number" => usdot_number,
"motor_carrage_number" => motor_carrage_number,
"address" => address,
"city_state_zip" => city_state_zip,
"mailing_address" => mailing_address,
"mailing_address_city_state_zip" => mailing_address_city_state_zip,
"phone_number" => phone_number,
"fax_number" => fax_number,
"review_date" => review_date,
"insurance_data_url" => insurance_data_url,
"number_of_tractors" => number_of_tractors,
"number_of_trailers" => number_of_trailers,
"number_of_trucks" => number_of_trucks,
"safety_rating_url" => safety_rating_url,
"safety_rating" => safety_rating
}

 end

end
