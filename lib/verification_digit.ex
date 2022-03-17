defmodule VerificationDigit do

  @verification %{
    "0" => "00",
    "1" => "01",
    "2" => "02",
    "3" => "03",
    "4" => "04",
    "5" => "05",
    "6" => "06",
    "7" => "07",
    "8" => "08",
    "9" => "09",
    "A" => "10",
    "B" => "11",
    "C" => "12",
    "D" => "13",
    "E" => "14",
    "F" => "15",
    "G" => "16",
    "H" => "17",
    "I" => "18",
    "J" => "19",
    "K" => "20",
    "L" => "21",
    "M" => "22",
    "N" => "23",
    "&" => "24",
    "O" => "25",
    "P" => "26",
    "Q" => "27",
    "R" => "28",
    "S" => "29",
    "T" => "30",
    "U" => "31",
    "V" => "32",
    "W" => "33",
    "X" => "34",
    "Y" => "35",
    "Z" => "36",
    " " => "37",
    "Ñ" => "38",
    "Ñ" => "38"
  }

  # Regresa el número verificador
  def calculate(rfc_12_digits) do
    number =
      rfc_12_digits
      |> String.graphemes()
      |> Enum.map(fn char -> Map.get(@verification, char) end)
      |> Enum.with_index()
      |> Enum.reduce(0, fn {number, index}, acc ->
          String.to_integer(number) * (13 - index) + acc
        end)
      |> Kernel.rem(11)

    cond do
      number == 0 -> "0"
      number == 1 -> "A"
      number in [2, 11] -> to_string(11 - number)
      true -> to_string(11 - number)
    end
  end
end
