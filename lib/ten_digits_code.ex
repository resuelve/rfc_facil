defmodule TenDigitsCode do
  @doc """
  Formado por letras que conforman el nombre, apellido paterno y apellido materno y la fecha de nacimiento.any()

    - Primera letra del apellido paterno
      - Si la primera letra del apellido paterno empieza con Ñ, se usa la letra X
    - Primera vocal interna del apellido paterno
      - Si no tiene una vocal, se usa la segunda letra del apellido paterno
    - Primera letra del apellido materno
      - Si no tiene apellido materno, se usan las 2 letras del apellido paterno
    - Primera letra del nombre
    - Los digitos individuales de la fecha de nacimiento en el formato YYMMDD
  """

  @vowels ~w(a e i o u)

  @avoidable_words ~w(de el y del los la las da das der di die dd le les mac mc van von)

  @avoidable_names ["maria", "jose", "ma"]

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

  @spec calculate(String.t(), String.t(), String.t(), Date.t()) :: String.t()
  def calculate(name, lastname, lastname2, birthdate) do
    name = Common.normalize(name)
    lastname = Common.normalize(lastname || "")
    lastname2 = Common.normalize(lastname2 || "")

    first_step = String.upcase(name_part(name, lastname, lastname2))

    alphabet_key =
      if Map.has_key?(@forbidden_words, first_step), do: Map.get(@forbidden_words, first_step), else: first_step

    alphabet_key <> Timex.format!(birthdate, "%y%m%d", :strftime)
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
