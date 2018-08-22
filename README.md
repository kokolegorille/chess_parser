# ChessParser

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `chess_parser` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:chess_parser, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/chess_parser](https://hexdocs.pm/chess_parser).

## Sample usage

iex> {:ok, trees} = ChessParser.process_file "./test/fixtures/GRENKEChessClassic2018.pgn"
iex> trees |> Enum.map(fn {:tree, tags, _elems} -> ChessParser.tags_to_game_info(tags) end)