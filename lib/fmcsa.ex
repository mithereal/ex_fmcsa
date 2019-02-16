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

 companies = marshall_companies(c)

 end

 def fetch_company_names do
 names = Enum.map(@states, fn(state) ->
 fetch_companies_by_state(state)
 end)
 end

  def marshall_companies(%{:error, data}) do
    %{:error, data}
  end

 def marshall_companies(response) do
    companies = Enum.map(response, fn x ->
      name = case(x)do
        {_,_,[{_,[{_,url}],[name]},_]} -> {name, url}
        {_, _, [city_state]} -> nil
        _ -> %{:error, "unable to extract page content"}
      end
      name
    end)

       case(companies)do
       c = Enum.reject(companies, &is_nil/1)
       [companies] -> %{:ok, c}
       %{:error, content} -> %{:error, content}
       _ -> %{:error, "an error occurred"}
       end
 end

def marshall_profile(%{:error, data}) do
 %{:error, data}
 end

 def marshall_profile(response) do
    {main,alt} = response

    main_res = case(main) do
    _ -> %{:error,"unable to extract profile content"}
    end

    alt_res = case(alt) do
    _ -> %{:error, "unable to extract profile content"}
    end

    case( main_res = %{:error} || alt_res = %{:error} ) do
    true -> %{:error, {main_res, alt_res}}
    false -> profile = %{}
              %{:ok, profile}
    end

    #    [
    #      {"tr", [{"class", "MiddleTDFMCSA"}],
    #        [
    #          {"td", [_], ["USDOT Number"]},
    #          {"td", [], [":"]},
    #          {"td", [_], [usdot_number]}
    #        ]},
    #      {"tr", [{"class", "MiddleTDFMCSA"}],
    #        [
    #          {"td", [_], ["Address"]},
    #          {"td", [], [":"]},
    #          {"td", [_],
    #            [
    #              address,
    #              {"br", [], []},
    #              city_state_zip
    #            ]}
    #        ]},
    #      {"tr", [{"class", "MiddleTDFMCSA"}],
    #        [
    #          {"td", [_], ["Telephone"]},
    #          {"td", [], [":"]},
    #          {"td", [_], [phone_number]}
    #        ]},
    #      {"tr", [{"class", "MiddleTDFMCSA"}],
    #        [
    #          {"td", [_], ["Review Date"]},
    #          {"td", [], [":"]},
    #          {"td", [_], [review_date]}
    #        ]},
    #      {"tr", [{"class", "MiddleTDFMCSA"}],
    #        [
    #          {"td", [_],
    #            ["Licensing & Insurance Status"]},
    #          {"td", [], [":"]},
    #          {"td", [_],
    #            [
    #              {"a",
    #                [
    #                  {"href",
    #                    insurance_data_url},
    #                  {"target", "_blank"}
    #                ], ["Insurance Data"]}
    #            ]}
    #        ]},
    #      {"tr", [{"class", "MiddleTDFMCSA"}],
    #        [
    #          {"td", [_],
    #            ["Number of Tractors"]},
    #          {"td", [_], [":"]},
    #          {"td", [], [number_of_tractors]}
    #        ]}
    #    ] = main



    #    [
    #      {"tr", [{"class", "MiddleAltTDFMCSA"}],
    #        [
    #          {"td", [_], ["Name"]},
    #          {"td", [], [":"]},
    #          {"td", [_],
    #            [name]}
    #        ]},
    #      {"tr", [{"class", "MiddleAltTDFMCSA"}],
    #        [
    #          {"td", [_], ["MC #"]},
    #          {"td", [], [":"]},
    #          {"td", [_], [motor_carrage_number]}
    #        ]},
    #      {"tr", [{"class", "MiddleAltTDFMCSA"}],
    #        [
    #          {"td", [_], ["Mailing Address"]},
    #          {"td", [], [":"]},
    #          {"td", [_],
    #            [
    #              mailing_address,
    #              {"br", [], []},
    #              mailing_address_city_state_zip
    #            ]}
    #        ]},
    #      {"tr", [{"class", "MiddleAltTDFMCSA"}],
    #        [
    #          {"td", [_], ["Fax"]},
    #          {"td", [], [":"]},
    #          {"td", [_], [fax_number]}
    #        ]},
    #      {"tr", [{"class", "MiddleAltTDFMCSA"}],
    #        [
    #          {"td", [_],
    #            ["Safety Rating"]},
    #          {"td", [], [":"]},
    #          {"td", [_],
    #            [{"span", [_], [safety_rating]}]}
    #        ]},
    #      {"tr", [{"class", "MiddleAltTDFMCSA"}],
    #        [
    #          {"td", [_],
    #            [
    #              "Most recent ",
    #              {"a",
    #                [
    #                  {"href",
    #                    safety_rating_url},
    #                  {"target", "_blank"}
    #                ], ["Safety Rating Data"]}
    #            ]}
    #        ]},
    #      {"tr", [{"class", "MiddleAltTDFMCSA"}],
    #        [{"td", [_], []}]},
    #      {"tr", [{"class", "MiddleAltTDFMCSA"}],
    #        [
    #          {"td", [_],
    #            [_]},
    #          {"td", [_], [":"]},
    #          {"td", [], [number_of_trucks]}
    #        ]},
    #      {"tr", [{"class", "MiddleAltTDFMCSA"}],
    #        [
    #          {"td", [_],
    #            [_]},
    #          {"td", [_], [":"]},
    #          {"td", [], [number_of_trailers]}
    #        ]}
    #    ] = alt

      # %{
      #"name" => name,
      #"usdot_number" => usdot_number,
      #"motor_carrage_number" => motor_carrage_number,
      #"address" => address,
      #"city_state_zip" => city_state_zip,
      #"mailing_address" => mailing_address,
      #"mailing_address_city_state_zip" => mailing_address_city_state_zip,
      #"phone_number" => phone_number,
      #"fax_number" => fax_number,
      #"review_date" => review_date,
      #"insurance_data_url" => insurance_data_url,
      #"number_of_tractors" => number_of_tractors,
      #"number_of_trailers" => number_of_trailers,
      #"number_of_trucks" => number_of_trucks,
      #"safety_rating_url" => safety_rating_url,
      #"safety_rating" => safety_rating
      #}

 end

 def fetch_company_profile(url) do
    response = HTTPotion.get(@primary_url <> url)
    html = response.body
    main = Floki.find(html, "tr.MiddleTDFMCSA")
    alt = Floki.find(html, "tr.MiddleAltTDFMCSA")
    marshall_profile({main,alt})

 end

end
