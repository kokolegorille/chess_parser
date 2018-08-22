defmodule ChessParserTest do
  use ExUnit.Case
  doctest ChessParser

  test "greets the world" do
    assert ChessParser.hello() == :world
  end
end
