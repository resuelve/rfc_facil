defmodule RfcFacil do
  @moduledoc """
  Documentation for RfcFacil.
  """

  alias RfcFacil.NaturalPerson

  @doc """
  Hello world.
  """
  def for_natural_person(name, lastname1, lastname2, birthdate) do
    NaturalPerson.calculate(name, lastname1, lastname2, birthdate)
  end
end
