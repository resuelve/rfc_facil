defmodule Common do
  def normalize(string) do
    string
    |> String.normalize(:nfd)
    |> String.codepoints()
    |> Enum.reject(&Regex.match?(~r/[^"̃A-Za-z&\s]/u, &1))
    |> Enum.join()
    |> String.downcase
  end
end
