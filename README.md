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

```elixir
iex> {:ok, trees} = ChessParser.load_file "./test/fixtures/GRENKEChessClassic2018.pgn"
iex> trees |> Enum.map(fn {:tree, tags, _elems} -> ChessParser.tags_to_game_info(tags) end)
iex> trees |> Enum.map(& ChessParser.dump_tree(&1)) |> IO.puts
```

30/11/2018
Update lexer to fix bogus tags

eg. [Site "Moscow 51/104 [Tal,M]"]

Replace in lexer

TAG            = \[[^\]]*\]

with the more specific

TAG            = \[.*\".*\"\s?\]