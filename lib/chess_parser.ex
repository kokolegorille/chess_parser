defmodule ChessParser do
  @moduledoc """
  Documentation for ChessParser.
  """
  @max_string_size 80

  @type tag :: {:tag, integer(), charlist()}
  @type elem :: {atom(), integer(), charlist()} | {:variation, list(elem())}
  @type tree :: {:tree, list(tag), list(elem)}

  @spec load_file(String.t()) :: {:ok, list(tree())} | {:error, term()}
  def load_file(filename) when is_binary(filename) do
    with {:ok, pgn} <- File.read(filename) do
      load_string(pgn)
    else
      _ -> {:error, "could not process pgn"}
    end
  end

  @spec load_string(String.t()) :: {:ok, list(tree())} | {:error, term()}
  def load_string(pgn) when is_binary(pgn) do
    with {:ok, tokens, _} <- pgn |> remove_bom_char() |> to_charlist() |> :pgn_lexer.string(),
         {:ok, games} <- tokens |> :pgn_parser.parse() do
      {:ok, games}
    else
      _ -> {:error, "could not process pgn"}
    end
  end

  @spec dump_tree(tree()) :: {:ok, String.t()}
  def dump_tree({:tree, tags, elems}) do
    pgn =
      elems
      |> dump_elems()
      |> format_pgn()

    result = [dump_tags(tags), pgn <> "\n\n"] |> Enum.join("\n\n")
    {:ok, result}
  end

  @spec tags_to_game_info(list(tag())) :: map()
  def tags_to_game_info(tags) do
    tags
    |> Enum.reduce(%{}, fn {:tag, _line, tag}, acc ->
      [key | tail] =
        tag
        |> sanitize_tag()
        |> String.split(" ")

      acc |> Map.put(key, sanitize_tag_value(tail))
    end)
  end

  # PRIVATE
  # Split long pgn string into chunks of 80 chars max, cutting at words boundary
  defp format_pgn(pgn) do
    pgn
    |> String.split(~r{(\ |\r\n\|\r|\n)})
    |> format_elems()
    |> Enum.join("\n")
  end

  # Split long pgn string tokens into chunks of 80 chars max, cutting at words boundary
  def format_elems(elems) do
    format_elems(elems, [], "", 0)
  end

  defp format_elems([], acc, current, _current_size), do: [current | acc] |> Enum.reverse()

  defp format_elems([head | tail], acc, current, current_size) do
    new_size = current_size + String.length(head) + 1

    if new_size > @max_string_size do
      format_elems(tail, [current | acc], head, String.length(head))
    else
      format_elems(tail, acc, current <> " " <> head, new_size)
    end
  end

  defp dump_tags(tags) do
    tags
    |> Enum.map(&dump_tag(&1))
    |> Enum.join("\n")
  end

  defp dump_tag({:tag, _, value}), do: sanitize_value(value)

  defp dump_elems(elems) do
    elems
    |> Enum.map(&dump_elem(&1))
    |> Enum.join(" ")
  end

  defp dump_elem({_, _, value}), do: sanitize_value(value)
  defp dump_elem({:variation, elems}), do: "(#{dump_elems(elems)})"

  defp sanitize_value(value) when is_list(value) do
    value |> List.to_string()
  end

  defp sanitize_tag(tag) do
    tag
    |> List.to_string()
    |> String.trim_leading("[")
    |> String.trim_trailing("]")
  end

  defp sanitize_tag_value(tag_value) do
    tag_value
    |> Enum.join(" ")
    |> String.trim_leading("\"")
    |> String.trim_trailing("\"")
  end
  
  defp remove_bom_char(string) do
    String.trim(pgn, "\uFEFF")
  end
end
