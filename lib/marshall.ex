defmodule Marshall do
  @moduledoc """
  data marshalls.
  """

  def fetch(data) do

    case(data) do
      [{"td", [{"style", "white-space:nowrap"}], ["USDOT Number"]}, {"td", [], [":"]}, _] ->
        {:ok, fetch_dot(data)}

      [
        {"td", [{"style", "white-space:nowrap"}, {"valign", "top"}], ["Address"]},
        {"td", [], [":"]},
        _
      ] ->
        {:ok, fetch_address(data)}

      _ ->
        {:error, "unable to extract content"}
    end
  end

  def fetch_dot(data) do
    dot =
      case(data) do
        [{"td", [{"style", "white-space:nowrap"}], ["USDOT Number"]}, {"td", [], [":"]}, _] ->
          [{"td", [{"style", "white-space:nowrap"}], ["USDOT Number"]}, {"td", [], [":"]}, el] =
            data

          {"td", [{"nowrap", "nowrap"}, {"width", "98%"}], [dot]} = el
          dot

        _ ->
          ""
      end

    {"USDOT Number", dot}
  end

  def fetch_address(data) do
    result =
      case(data) do
        [
          {"td", [{"style", "white-space:nowrap"}, {"valign", "top"}], ["Address"]},
          {"td", [], [":"]},
          _
        ] ->
          [
            {"td", [{"style", "white-space:nowrap"}, {"valign", "top"}], ["Address"]},
            {"td", [], [":"]},
            el
          ] =
            data

          {"td", [{"width", "98%"}],
            address_list } = el

          [
            address,
            {"br", [], []},
            city
          ] = address_list

          address = address |> String.replace("\r", "") |> String.replace("\n", "") |> String.replace("\t", "") |> String.trim()
          city = city |> String.replace("\r", "") |> String.replace("\n", "") |> String.replace("\t", "") |> String.trim()

            {address,city}
        _ ->
          ""
      end

    {"Address", result}
  end

  def profile({:error, data}) do
    {:error, data}
  end

  def profile(response) do
    {main, alt} = response

    main_res = {:error, "placeholder"}

    element =
      Enum.map(main, fn x ->
        y =
          case(x) do
            {"tr", [{"class", "MiddleTDFMCSA"}], _} ->
              {"tr", [{"class", "MiddleTDFMCSA"}], data} = x
              fetch(data)

            _ ->
              {:error, "unable to extract profile content"}
          end
      end)


    alt_res =
      case(alt) do
        _ ->
          {:error, "unable to extract profile content"}
      end

    {main_status, _} = main_res
    {alt_status, _} = alt_res

    error = true

    case(error) do
      true ->
        {:error, {main_res, alt_res}}

      false ->
        profile = %{}
        {:ok, profile}
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
    # "name" => name,
    # "usdot_number" => usdot_number,
    # "motor_carrage_number" => motor_carrage_number,
    # "address" => address,
    # "city_state_zip" => city_state_zip,
    # "mailing_address" => mailing_address,
    # "mailing_address_city_state_zip" => mailing_address_city_state_zip,
    # "phone_number" => phone_number,
    # "fax_number" => fax_number,
    # "review_date" => review_date,
    # "insurance_data_url" => insurance_data_url,
    # "number_of_tractors" => number_of_tractors,
    # "number_of_trailers" => number_of_trailers,
    # "number_of_trucks" => number_of_trucks,
    # "safety_rating_url" => safety_rating_url,
    # "safety_rating" => safety_rating
    # }
  end

  def companies({:error, data}) do
    {:error, data}
  end

  def companies(response) do
    companies =
      Enum.map(response, fn x ->
        name =
          case(x) do
            {_, _, [{_, [{_, url}], [name]}, _]} -> {name, url}
            {_, _, [city_state]} -> nil
            _ -> {:error, "unable to extract page content"}
          end

        name
      end)

    case(companies) do
      {:error, content} ->
        {:error, content}

      _ ->
        c = Enum.reject(companies, &is_nil/1)
        {:ok, c}
    end
  end
end
