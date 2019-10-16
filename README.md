# RfcFacil

**Librería para calcular el Registro Federal de Contribuyentes en México (RFC) - Elixir

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `rfc_facil` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:rfc_facil, "~> 0.1.0"}
  ]
end
```

## Usage

```elixir
RfcFacil.for_natural_person("Oscar", "For", "Bar", "1989-09-23")
```

# Contributors

- https://github.com/ketsalkuetspalin
- https://github.com/oscarolbe

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/rfc_facil](https://hexdocs.pm/rfc_facil).

