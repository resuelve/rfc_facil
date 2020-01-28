defmodule RfcFacil.MixProject do
  use Mix.Project

  def project do
    [
      app: :rfc_facil,
      version: "0.1.2",
      elixir: "~> 1.9",
      package: package(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:timex, "~> 3.1"}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md"],
      description: "Rfc generator",
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/resuelve/rfc_facil"}
    ]
  end
end
