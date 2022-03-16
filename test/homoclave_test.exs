defmodule HomoclaveTest do
  use ExUnit.Case

  test "should naturalPersonTenDigitsCode homoclave for simple name'" do
    assert Homoclave.calculate("Perez Garcia Juan") == "LN"
  end

  test "should naturalPersonTenDigitsCode same homoclave for names with and without accents'" do
    assert Homoclave.calculate("Perez Garcia Juan") == Homoclave.calculate("Pérez García Juan")
  end

  test "should naturalPersonTenDigitsCode homoclave for person with more that one name'" do
    assert Homoclave.calculate("Del real Anzures Jose Antonio") == "N9"
  end

  test "should naturalPersonTenDigitsCode homoclave for name with n-tilde'" do
    assert Homoclave.calculate("Muñoz Ortega Juan") == "T6"
  end

  test "should naturalPersonTenDigitsCode homoclave for name with multiple n-tilde'" do
    assert Homoclave.calculate("Muñoz Muñoz Juan") == "RZ"
  end

  test "should naturalPersonTenDigitsCode different homoclave for name with and without n-tilde'" do
    assert Homoclave.calculate("Muñoz Ortega Juan") != Homoclave.calculate("Munoz Ortega Juan")
  end

  test "should naturalPersonTenDigitsCode homoclave for name with u-umlaut'" do
    assert Homoclave.calculate("Argüelles Ortega Jesus") == "JF"
  end

  test "should naturalPersonTenDigitsCode same homoclave for name with and without u-umlaut'" do
    assert Homoclave.calculate("Argüelles Ortega Jesus") == Homoclave.calculate("Arguelles Ortega Jesus")
  end

  test "should naturalPersonTenDigitsCode homoclave for name with ampersand'" do
    assert Homoclave.calculate("Perez&Gomez Garcia Juan") == "2R"
  end

  test "should naturalPersonTenDigitsCode different homoclave for name with and without ampersand'" do
    assert Homoclave.calculate("Perez&Gomez Garcia Juan") != Homoclave.calculate("PerezGomez Garcia Juan")
  end

  test "should naturalPersonTenDigitsCode same homoclave for name with and without special-characters'" do
    assert Homoclave.calculate("Mc.Gregor O'Connor-Juarez Juan") == Homoclave.calculate("McGregor OConnorJuarez Juan")
  end
end
