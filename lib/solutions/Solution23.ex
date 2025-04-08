defmodule Solution23 do
  import Enum

  def solve do
    connections = read() |> Map.new()

    connections
    |> Map.new(fn {k, vals} ->
      {k, pairs(vals) |> filter(fn {x, y} -> Map.get(connections, x, []) |> member?(y) end)}
    end)
    |> map(fn {k, vals} -> vals |> map(fn {x, y} -> [k, x, y] end) end)
    |> filter(fn x -> length(x) > 0 end)
    |> reduce([], &++/2)
    |> filter(fn party -> party |> any?(&String.starts_with?(&1, "t")) end)
    |> count
  end

  def solve2 do
  end

  defp pairs(xs) do
    for x <- xs, y <- xs do
      {x, y}
    end
    |> filter(fn {x, y} -> x != y && x < y end)
  end

  defp read do
 
    path = Application.app_dir(:aoc, "priv/static/input/23.txt")

    case File.read(path) do
      {:ok, content} ->
        Util.lines(content)
        |> filter(&String.length(&1) > 0)
        |> map(&(String.split(&1, "-") |> sort() |> List.to_tuple()))
        |> group_by(&elem(&1, 0))
        |> map(fn {k, vals} -> {k, vals |> map(&elem(&1, 1))} end)

      end 
  end
end
