defmodule RfcFacil.NaturalPerson do
  @moduledoc """
  Utilidad para calcular los RFC's de persona físicas
  """

  @doc """
  Calcula el RFC de una persona física, siguiendo con la reglas usadas por
  el Registro Federal de Contribuyentes
  """
  @spec calculate(String.t(), String.t(), String.t(), String.t()) :: String.t()
  def calculate(name, lastname, lastname2, birthdate) do
    ten_digits_code =
      TenDigitsCode.calculate(name, lastname, lastname2, parse_date(birthdate))
    homoclave = Homoclave.calculate("#{lastname} #{lastname2} #{name}")
    digit = VerificationDigit.calculate(ten_digits_code <> homoclave)

    {:ok, ten_digits_code <> homoclave <> digit}
  end

  # Regresa la fecha de nacimiento en el formato correcto
  defp parse_date(birthdate) do
    Timex.parse!(birthdate, "%Y-%m-%d", :strftime)
  end
end
