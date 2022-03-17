defmodule RfcFacilTest do
  use ExUnit.Case

  test "Should generate rfc" do
    {:ok, rfc} = RfcFacil.for_natural_person("Oscar", "Foo", "Bar", "1989-02-21")
    assert rfc == "FOBO890221PI5"
  end

  test "calculate RFC when name is too short" do
    {:ok, rfc} = RfcFacil.for_natural_person("Alvaro", "de la O", "Lozano", "1940-12-01")
    assert rfc == "OLAL401201R99"

    {:ok, rfc} = RfcFacil.for_natural_person("Ernesto", "Ek", "Rivera", "2007-11-20")
    assert rfc == "ERER0711209E3"
  end

  test "calculate RFC for people with uncommon lastnames" do
    {:ok, rfc} = RfcFacil.for_natural_person("Dolores", "San Martín", "Dávalos", "1918-08-12")
    assert rfc == "SADD1808121G7"

    {:ok, rfc} = RfcFacil.for_natural_person("Antonio", "Jiménez", "Ponce de León", "1917-08-08")
    assert rfc == "JIPA170808M4A"
  end

  test "calculate RFC for people with just one lastname" do
    {:ok, rfc} = RfcFacil.for_natural_person("Juan", "Martínez", "", "1942-01-16")
    assert rfc == "MAJU420116BP3"

    {:ok, rfc} = RfcFacil.for_natural_person("Gerardo", "Zafra", "", "1925-11-15")
    assert rfc == "ZAGE251115EK7"
  end

  test "calculate RFC for people with prepositions or articles in their names" do
    {:ok, rfc} = RfcFacil.for_natural_person("Mario", "Sánchez", "de los Cobos", "1970-11-10")
    assert rfc == "SACM701110MT0"
  end

  test "calculate RFC for people with special characters in their name" do
    {:ok, rfc} = RfcFacil.for_natural_person("Roberto", "O'Farril", "Carballo", "1966-11-21")
    assert rfc == "OACR661121B47"
  end

  test "calculate RFC for people with only one vowel in their paternal last name" do
    {:ok, rfc} = RfcFacil.for_natural_person("Roberto", "Orff", "Carballo", "1966-11-21")
    assert rfc == "ORCR661121IL0"
  end

  test "calculate normal RFC" do
    {:ok, rfc} = RfcFacil.for_natural_person("Erick", "Madrid", "Cruz", "1989-03-09")
    assert rfc == "MACE890309659"
  end

  test "should build rfc for a natural person" do
    {:ok, rfc} = RfcFacil.for_natural_person("Josué", "Zarzosa", "de la Torre", "1987-08-05")
    assert rfc == "ZATJ870805CK6"
  end

  test "should build rfc for a natural person with verification digit 1" do
    {:ok, rfc} = RfcFacil.for_natural_person("Eliud", "Orozco", "Gomez", "1952-07-11")
    assert rfc == "OOGE520711151"
  end

  test "should build rfc for a natural person with verification digit A" do
    {:ok, rfc} = RfcFacil.for_natural_person("Saturnina", "Angel", "Cruz", "1921-11-12")
    assert rfc == "AECS211112JPA"
  end
end
