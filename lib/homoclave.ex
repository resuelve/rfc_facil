defmodule Homoclave do
  @doc """
  Cálculo de la homoclave de una persona física.
  """

  @alphabet %{
    " " => "00",
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
    "&" => "10",
    "A" => "11",
    "B" => "12",
    "C" => "13",
    "D" => "14",
    "E" => "15",
    "F" => "16",
    "G" => "17",
    "H" => "18",
    "I" => "19",
    "J" => "21",
    "K" => "22",
    "L" => "23",
    "M" => "24",
    "N" => "25",
    "O" => "26",
    "P" => "27",
    "Q" => "28",
    "R" => "29",
    "S" => "32",
    "T" => "33",
    "U" => "34",
    "V" => "35",
    "W" => "36",
    "X" => "37",
    "Y" => "38",
    "Z" => "39",
    "Ñ" => "40",
    "Ñ" => "40" # No tocar: Ñ con otra codificación identificada
  }

  @homonymy %{
    "0" => 1,
    "1" => 2,
    "2" => 3,
    "3" => 4,
    "4" => 5,
    "5" => 6,
    "6" => 7,
    "7" => 8,
    "8" => 9,
    "9" => "A",
    "10" => "B",
    "11" => "C",
    "12" => "D",
    "13" => "E",
    "14" => "F",
    "15" => "G",
    "16" => "H",
    "17" => "I",
    "18" => "J",
    "19" => "K",
    "20" => "L",
    "21" => "M",
    "22" => "N",
    "23" => "P",
    "24" => "Q",
    "25" => "R",
    "26" => "S",
    "27" => "T",
    "28" => "U",
    "29" => "V",
    "30" => "W",
    "31" => "X",
    "32" => "Y",
    "33" => "Z"
  }

  #  Regresa la clave diferenciadora de homonimia
  def calculate(fullname) do
    fullname
    |> Common.normalize()
    |> String.upcase()
    |> String.graphemes()
    |> Enum.map(fn char -> Map.get(@alphabet, char) end)
    |> Enum.join()
    |> String.graphemes()
    |> homonymy_operation()
  end

  # Calcula el resultado de multiplicar la lista de números
  # Se efectuaran las multiplicaciones de los números tomados de
  # dos en dos para la posición de la pareja
  # Se agrega un cero al inicio
  defp homonymy_operation(numbers) do
  result =
    numbers
    |> _homonymy_operation("0")
    |> Kernel.rem(1000)

  first_code =
    result
    |> Kernel.div(34)
    |> Integer.to_string()
    |> (&Map.get(@homonymy, &1)).()

  second_code =
    result
    |> Kernel.rem(34)
    |> Integer.to_string()
    |> (&Map.get(@homonymy, &1)).()

  "#{first_code}#{second_code}"
  end

  # Va multiplicando la pareja de números y sumando los resultados
  defp _homonymy_operation([], _), do: 0

  defp _homonymy_operation([next | remain], past_number) do
  next_number = String.to_integer(next)

  "#{past_number}#{next_number}"
  |> String.trim()
  |> String.to_integer()
  |> Kernel.*(next_number)
  |> Kernel.+(_homonymy_operation(remain, next_number))
  end
end
