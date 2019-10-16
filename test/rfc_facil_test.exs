defmodule RfcFacilTest do
  use ExUnit.Case

  test "Should generate rfc" do
    {:ok, rfc} = RfcFacil.for_natural_person("Oscar", "Foo", "Bar", "1989-02-21")
    assert rfc == "FOBO890221PI5"
  end
end
