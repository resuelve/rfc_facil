defmodule RfcFacil.NaturalPerson do
  @moduledoc """
  Utilidad para calcular los RFC's de persona físicas
  """

  @vowels ~w(a e i o u)

  @avoidable_words ~w(de el y del los la las da das der di die dd le les mac mc van von)

  @avoidable_names ["maria", "jose", "ma"]

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

  @forbidden_words %{
    "BUEI" => "BUEX",
    "BUEY" => "BUEX",
    "CACA" => "CACX",
    "CACO" => "CACX",
    "CAGA" => "CAGX",
    "CAGO" => "CAGX",
    "CAKA" => "CAKX",
    "COGE" => "COGX",
    "COJA" => "COJX",
    "COJE" => "COJX",
    "COJI" => "COJX",
    "COJO" => "COJX",
    "CULO" => "CULX",
    "FETO" => "FETX",
    "GUEY" => "GUEX",
    "JOTO" => "JOTX",
    "KACA" => "KACX",
    "KACO" => "KACX",
    "KAGA" => "KAGX",
    "KAGO" => "KAGX",
    "KOGE" => "KOGX",
    "KOJO" => "KOJX",
    "KAKA" => "KAKX",
    "KULO" => "KULX",
    "MAME" => "MAMX",
    "MAMO" => "MAMX",
    "MEAR" => "MEAX",
    "MEON" => "MEOX",
    "MION" => "MIOX",
    "MOCO" => "MOCX",
    "MULA" => "MULX",
    "PEDA" => "PEDX",
    "PEDO" => "PEDX",
    "PENE" => "PENX",
    "PUTA" => "PUTX",
    "PUTO" => "PUTX",
    "QULO" => "QULX",
    "RATA" => "RATX",
    "RUIN" => "RUIX"
  }

  @doc """
  Calcula el RFC de una persona física, siguiendo con la reglas usadas por
  el Registro Federal de Contribuyentes
  """
  @spec calculate(String.t(), String.t(), String.t(), String.t()) :: String.t()
  def calculate(name, lastname, lastname2, birthdate) do
    name = Common.normalize(name)
    lastname = Common.normalize(lastname)
    lastname2 = Common.normalize(lastname2)

    first_step = String.upcase(name_part(name, lastname, lastname2))

    alphabet_key =
      if Map.has_key?(@forbidden_words, first_step), do: Map.get(@forbidden_words, first_step), else: first_step

    rfc = alphabet_key <> birth_part(birthdate) <> Homoclave.calculate("#{lastname} #{lastname2} #{name}")

    digit =
      rfc
      |> String.upcase()
      |> verification_part()

    {:ok, rfc <> digit}
  end

  # Construye la primer parte del RFC en la que solo está involucrado el
  # nombre de la persona
  defp name_part(name, lastname, lastname2) do
    # Si los apellidos tienen artículos o preposiciones, deben eliminarse
    lastname = trim_words(lastname)
    lastname2 = trim_words(lastname2)
    length = String.length(lastname)
    check_name = get_names(name)

    cond do
      # Sin apellido paterno
      lastname in ["", nil] ->
        String.slice(lastname2, 0, 2) <> String.slice(check_name, 0, 2)

      # Sin apellido materno
      lastname2 in ["", nil] ->
        String.slice(lastname, 0, 2) <> String.slice(check_name, 0, 2)

      # Apellido paterno demasiado pequeño
      length <= 2 ->
        # Si la primera es consonante y la segunta es vocal aplica la regla basica de RFC
        # Caso contrario aplica regla de apellido corto
        if check_letter(lastname, 0, 1) === false and check_letter(lastname, 1, 1) === true do
          _name_part(check_name, lastname, lastname2)
        else
          String.slice(lastname, 0, 1) <>
          String.slice(lastname2, 0, 1) <>
          String.slice(check_name, 0, 2)
        end

      # Caso normal
      true ->
        _name_part(check_name, lastname, lastname2)
    end
  end

  # Caso normal
  # 1. La primera letra del apellido paterno y la siguiente primera vocal del mismo.
  # 2. La primera letra del apellido materno.
  # 3. La primera letra del nombre.
  defp _name_part(name, lastname, lastname2) do
    {first_char, remainder} = String.next_grapheme(lastname)

    first_char <>
      paternal_surname_letter_2(remainder) <>
      String.slice(lastname2, 0, 1) <>
      String.slice(name, 0, 1)
  end

  # Elimina las preposiciones o artículos del apellido
  # Estos no deben ser considerados en el RFC
  defp trim_words(lastname) do
    lastname
    |> String.split(" ")
    |> Enum.reduce("", fn word, acc ->
      word
      |> String.downcase()
      |> (&Enum.member?(@avoidable_words, &1)).()
      |> if do
           acc
         else
           "#{acc} #{word}"
         end
      |> String.trim()
    end)
  end

  # Regresa la fecha de nacimiento en el formato correcto
  defp birth_part(birthdate) do
    birthdate
    |> Timex.parse!("%Y-%m-%d", :strftime)
    |> Timex.format!("%y%m%d", :strftime)
  end

  # Regresa el número verificador
  defp verification_part(rfc) do
    number =
      rfc
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

  # Regresa la siguiente vocal, o si no hay, la segunda letra
  defp paternal_surname_letter_2(paternal_surname) do
    vowel = next_vowel(paternal_surname)

    if vowel do
      vowel
    else
      {next_letter, _} = String.next_grapheme(paternal_surname)
      next_letter
    end
  end

  # Regresa la siguiente vocal
  defp next_vowel(string) do
    with {char, remainder} <- String.next_grapheme(string) do
      if Enum.member?(@vowels, char), do: char, else: next_vowel(remainder)
    else
      nil -> nil
    end
  end

  # Verifica las primeras 2 letras si es vocal o no
  defp check_letter(word, start, amount) do
    result = String.slice(word, start, amount)
    if Enum.member?(@vowels, result), do: true, else: false
  end

  # Obtenemos el primer o segundo nombre
  # 1. Si es nombre unico devuelve el mismo
  # 2. Si es compuesto pasa por compound_name
  defp get_names(string) do
    split =
      string
      |> trim_words()
      |> String.split(" ")

    if length(split) > 1 do
      compound_name(Enum.at(split, 0), Enum.at(split, 1))
    else
      trim_words(string)
    end
  end

  # Verifica que el primer nombre no sea jose, maria, ma
  # 1. Si el primer nombre existe en la lista devuelve el segundo nombre
  # 2. Si el primero no existe devuelve el primero
  defp compound_name(first_name, second_name) do
    if Enum.member?(@avoidable_names, first_name) === true do
      second_name
    else
      first_name
    end
  end
end
