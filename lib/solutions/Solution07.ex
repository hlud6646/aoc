defmodule Solution7 do
  import Enum
  import Util

  def solve, do: f7([&+/2, &*/2])

  def solve2, do: f7([&+/2, &*/2, &integer_concat/2])

  defp eval(terms, operators) do
    case terms do
      [] ->
        []

      [x] ->
        [x]

      [a, b | rest] ->
        operators
        |> map(fn f -> eval([f.(a, b) | rest], operators) end)
        |> then(&List.flatten/1)
    end
  end

  def f7(operators) do
    read()
    |> filter(fn {n, terms} -> member?(eval(terms, operators), n) end)
    |> map(fn {n, _} -> n end)
    |> sum
  end

  defp integer_concat(x, y) do
    String.to_integer(to_string(x) <> to_string(y))
  end

  defp read do
    path = Application.app_dir(:aoc, "priv/static/input/7.txt")

    case File.read(path) do
      {:ok, content} ->
        lines(content)
        |> map(&String.split/1)
        |> map(fn line ->
          {
            at(line, 0) |> then(&String.slice(&1, 0..-2//1)) |> then(&String.to_integer/1),
            drop(line, 1) |> map(&String.to_integer/1)
          }
        end)
    end
  end
end
