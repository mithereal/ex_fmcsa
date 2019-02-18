defmodule FmcsaTest do
  use ExUnit.Case
  doctest Fmcsa

  test "Fetch Companies By State" do
    {_, response} = Fmcsa.fetch_companies_by_state("AZ")
    assert Enum.count(response) != 0
  end
end
