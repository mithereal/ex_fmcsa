defmodule FmcsaTest do
  use ExUnit.Case
  doctest Fmcsa

  test "Fetch Companies By State" do
    {status, response} = Fmcsa.fetch_companies_by_state("AZ")

    case(status) do
      :error -> assert false == false
      :ok -> assert Enum.count(response) != 0
    end
  end
end
