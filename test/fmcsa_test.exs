defmodule FmcsaTest do
  use ExUnit.Case
  doctest Fmcsa

  test "Fetch Companies By State" do
    response = Fmcsa.fetch_companies_by_state("AZ")
    assert Enum.count(response) != 0
  end

  test "Fetch Company Data" do
    response = Fmcsa.fetch_companies_by_state("AZ")
{_,url} = List.first(response)
    assert Enum.count(Fmcsa.fetch_company_profile(url)) != 0
  end
end
