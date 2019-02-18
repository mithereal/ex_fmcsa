defmodule Marshall do
  @moduledoc """
  data marshalls.
  """

  def fetch(data) do
    case(data) do
      [{"td", [{"style", "white-space:nowrap"}], ["USDOT Number"]}, {"td", [], [":"]}, _] ->
        fetch_dot(data)

      [{"td", [{"style", "white-space:nowrap"}], ["MC #"]}, {"td", [], [":"]}, _] ->
        fetch_mc(data)

      [
        {"td", [{"style", "white-space:nowrap"}, {"valign", "top"}], ["Address"]},
        {"td", [], [":"]},
        _
      ] ->
        fetch_address(data)

      [
        {"td", [{"style", "white-space:nowrap"}, {"valign", "top"}], ["Telephone"]},
        {"td", [], [":"]},
        _
      ] ->
        fetch_telephone(data)

      [
        {"td", [{"width", "1%"}, {"style", "white-space:nowrap"}], ["Number of Tractors"]},
        {"td", [{"width", "1%"}], [":"]},
        _
      ] ->
        fetch_tractors(data)

      [
        {"td", [{"style", "white-space:nowrap"}], ["Name"]},
        {"td", [], [":"]},
        _
      ] ->
        fetch_name(data)

      [
        {"td", [{"style", "white-space:nowrap"}], ["Mailing Address"]},
        {"td", [], [":"]},
        _
      ] ->
        fetch_mailing_address(data)

      [
        {"td", [{"style", "white-space:nowrap"}], ["Fax"]},
        {"td", [], [":"]},
        _
      ] ->
        fetch_fax(data)

      [
        {"td", [{"width", "1%"}, {"style", "white-space:nowrap"}], ["Number of Trucks"]},
        {"td", [{"width", "1%"}], [":"]},
        _
      ] ->
        fetch_number_of_trucks(data)

      [
        {"td", [{"width", "1%"}, {"style", "white-space:nowrap"}], ["Number of Trailers"]},
        {"td", [{"width", "1%"}], [":"]},
        _
      ] ->
        fetch_number_of_trailers(data)

      _ ->
        nil
    end
  end

  def fetch_dot(data) do
    result =
      case(data) do
        [{"td", [{"style", "white-space:nowrap"}], ["USDOT Number"]}, {"td", [], [":"]}, _] ->
          [{"td", [{"style", "white-space:nowrap"}], ["USDOT Number"]}, {"td", [], [":"]}, el] =
            data

          {"td", [{"nowrap", "nowrap"}, {"width", "98%"}], [selected]} = el
          selected

        _ ->
          ""
      end

    {"USDOT Number", result}
  end

  def fetch_name(data) do
    result =
      case(data) do
        [
          {"td", [{"style", "white-space:nowrap"}], ["Name"]},
          {"td", [], [":"]},
          _
        ] ->
          [
            {"td", [{"style", "white-space:nowrap"}], ["Name"]},
            {"td", [], [":"]},
            el
          ] = data

          {"td", [{"style", "white-space:wrap"}, {"width", "98%"}], [selected]} = el
          selected

        _ ->
          ""
      end

    {"Name", result}
  end

  def fetch_mc(data) do
    result =
      case(data) do
        [
          {"td", [{"style", "white-space:nowrap"}], ["MC #"]},
          {"td", [], [":"]},
          _
        ] ->
          [
            {"td", [{"style", "white-space:nowrap"}], ["MC #"]},
            {"td", [], [":"]},
            el
          ] = data

          {"td", [{"nowrap", "nowrap"}, {"width", "98%"}], [selected]} = el
          selected

        _ ->
          ""
      end

    {"MC", result}
  end

  def fetch_mailing_address(data) do
    result =
      case(data) do
        [
          {"td", [{"style", "white-space:nowrap"}], ["Mailing Address"]},
          {"td", [], [":"]},
          _
        ] ->
          [
            {"td", [{"style", "white-space:nowrap"}], ["Mailing Address"]},
            {"td", [], [":"]},
            el
          ] = data

          {"td", _, address_list} = el

          count = Enum.count(address_list)

          case(count) do
            0 ->
              [
                address,
                {"br", [], []},
                city
              ] = address_list

              address =
                address
                |> String.replace("\r", "")
                |> String.replace("\n", "")
                |> String.replace("\t", "")
                |> String.trim()

              city =
                city
                |> String.replace("\r", "")
                |> String.replace("\n", "")
                |> String.replace("\t", "")
                |> String.trim()

              {address, city}

            _ ->
              {"", ""}
          end
      end

    {"Mailing Address", result}
  end

  def fetch_fax(data) do
    result =
      case(data) do
        [
          {"td", [{"style", "white-space:nowrap"}], ["Fax"]},
          {"td", [], [":"]},
          _
        ] ->
          [
            {"td", [{"style", "white-space:nowrap"}], ["Fax"]},
            {"td", [], [":"]},
            el
          ] = data

          {"td", [{"width", "98%"}], [selected]} = el
          selected

        _ ->
          ""
      end

    {"Fax", result}
  end

  def fetch_number_of_trucks(data) do
    result =
      case(data) do
        [
          {"td", [{"width", "1%"}, {"style", "white-space:nowrap"}], ["Number of Trucks"]},
          {"td", [{"width", "1%"}], [":"]},
          _
        ] ->
          [
            {"td", [{"width", "1%"}, {"style", "white-space:nowrap"}], ["Number of Trucks"]},
            {"td", [{"width", "1%"}], [":"]},
            el
          ] = data

          {"td", [], [selected]} = el
          selected

        _ ->
          ""
      end

    {"Number of Trucks", result}
  end

  def fetch_number_of_trailers(data) do
    result =
      case(data) do
        [
          {"td", [{"width", "1%"}, {"style", "white-space:nowrap"}], ["Number of Trailers"]},
          {"td", [{"width", "1%"}], [":"]},
          _
        ] ->
          [
            {"td", [{"width", "1%"}, {"style", "white-space:nowrap"}], ["Number of Trailers"]},
            {"td", [{"width", "1%"}], [":"]},
            el
          ] = data

          {"td", [], [selected]} = el
          selected

        _ ->
          ""
      end

    {"Number of Trailers", result}
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
          ] = data

          {"td", [{"width", "98%"}], address_list} = el

          [
            address,
            {"br", [], []},
            city
          ] = address_list

          address =
            address
            |> String.replace("\r", "")
            |> String.replace("\n", "")
            |> String.replace("\t", "")
            |> String.trim()

          city =
            city
            |> String.replace("\r", "")
            |> String.replace("\n", "")
            |> String.replace("\t", "")
            |> String.trim()

          {address, city}

        _ ->
          ""
      end

    {"Address", result}
  end

  def fetch_telephone(data) do
    result =
      case(data) do
        [
          {"td", [{"style", "white-space:nowrap"}, {"valign", "top"}], ["Telephone"]},
          {"td", [], [":"]},
          _
        ] ->
          [
            {"td", [{"style", "white-space:nowrap"}, {"valign", "top"}], ["Telephone"]},
            {"td", [], [":"]},
            el
          ] = data

          {"td", [{"width", "98%"}], [selected]} = el
          selected

        _ ->
          ""
      end

    {"Telephone", result}
  end

  def fetch_tractors(data) do
    ##  IO.inspect(data)
    result =
      case(data) do
        [
          {"td", [{"width", "1%"}, {"style", "white-space:nowrap"}], ["Number of Tractors"]},
          {"td", [{"width", "1%"}], [":"]},
          _
        ] ->
          [
            {"td", [{"width", "1%"}, {"style", "white-space:nowrap"}], ["Number of Tractors"]},
            {"td", [{"width", "1%"}], [":"]},
            el
          ] = data

          {"td", [], [selected]} = el
          selected

        _ ->
          ""
      end

    {"Number of Tractors", result}
  end

  def profile({:error, data}) do
    {:error, data}
  end

  def profile(response) do
    profile = %{
      name: "",
      phone: "",
      fax: "",
      mc: "",
      dot: "",
      mailing_address: "",
      address: "",
      number_of_trucks: "",
      number_of_trailers: "",
      number_of_tractors: ""
    }

    {main, alt} = response

    main_data =
      Enum.map(main, fn x ->
        case(x) do
          {"tr", [{"class", "MiddleTDFMCSA"}], _} ->
            {"tr", [{"class", "MiddleTDFMCSA"}], data} = x
            fetch(data)

          _ ->
            nil
        end
      end)

    alt_data =
      Enum.map(alt, fn x ->
        case(x) do
          {"tr", [{"class", "MiddleAltTDFMCSA"}], _} ->
            {"tr", [{"class", "MiddleAltTDFMCSA"}], data} = x
            fetch(data)

          _ ->
            nil
        end
      end)

    main_data = Enum.reject(main_data, &is_nil/1)
    alt_data = Enum.reject(alt_data, &is_nil/1)

    [
      {"USDOT Number", dot},
      {"Address", address},
      {"Telephone", phone},
      {"Number of Tractors", tractors}
    ] = main_data

    profile = Map.put(profile, :dot, dot)
    profile = Map.put(profile, :address, address)
    profile = Map.put(profile, :phone, phone)
    profile = Map.put(profile, :number_of_tractors, tractors)

    count = Enum.count(alt_data)

    profile =
      case(count) do
        5 ->
          [
            {"Name", name},
            {"Mailing Address", mailing_address},
            {"Fax", fax},
            {"Number of Trucks", trucks},
            {"Number of Trailers", trailers}
          ] = alt_data

          profile = Map.put(profile, :name, name)
          profile = Map.put(profile, :mc, "")
          profile = Map.put(profile, :mailing_address, mailing_address)
          profile = Map.put(profile, :fax, fax)
          profile = Map.put(profile, :number_of_trucks, trucks)
          profile = Map.put(profile, :number_of_trailers, trailers)
          profile

        6 ->
          [
            {"Name", name},
            {"MC", mc},
            {"Mailing Address", mailing_address},
            {"Fax", fax},
            {"Number of Trucks", trucks},
            {"Number of Trailers", trailers}
          ] = alt_data

          profile = Map.put(profile, :name, name)
          profile = Map.put(profile, :mc, mc)
          profile = Map.put(profile, :mailing_address, mailing_address)
          profile = Map.put(profile, :fax, fax)
          profile = Map.put(profile, :number_of_trucks, trucks)
          profile = Map.put(profile, :number_of_trailers, trailers)
          profile
      end

    main_res =
      case(Enum.count(main_data) > 0) do
        true ->
          {:ok, main_data}

        false ->
          {:error, "unable to extract content"}
      end

    alt_res =
      case(Enum.count(alt_data) > 0) do
        true ->
          {:ok, alt_data}

        false ->
          {:error, "unable to extract content"}
      end

    {main_status, _} = main_res
    {alt_status, _} = alt_res

    error = main_status == alt_status == :error

    case(error) do
      true ->
        {:error, {main_res, alt_res}}

      false ->
        {:ok, profile}
    end
  end

  def companies({:error, data}) do
    {:error, data}
  end

  def companies(response) do
    companies =
      Enum.map(response, fn x ->
        name =
          case(x) do
            {_, _, [{_, [{_, url}], [name]}, _]} ->
              {name, url}

            _ ->
              {:error, "unable to extract page content"}
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

  def company_names(response) do
    companies =
      Enum.map(response, fn x ->
        name =
          case(x) do
            {_, _, [{_, [{_, url}], [name]}, _]} ->
              {name, url}

            _ ->
              nil
          end

        name
      end)

    c = Enum.reject(companies, &is_nil/1)
    {:ok, c}
  end

  def json(data) do
    data
  end
end
