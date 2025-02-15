defmodule Solution3 do
  import Enum

  def solve do
    extract_multiplications(read())
  end

  def solve2 do
    String.split(read(), "do()")
    |> map(&at(String.split(&1, "don't()"), 0))
    |> map(&extract_multiplications/1)
    |> sum()
  end

  defp extract_multiplications(chunk) do
    Regex.scan(~r/mul\((\d+),(\d+)\)/, chunk, capture: :all_but_first)
    |> map(fn [x, y] -> String.to_integer(x) * String.to_integer(y) end)
    |> sum()
  end

  defp read do
    path = Application.app_dir(:aoc, "priv/static/input/3.txt")

    case File.read(path) do
      {:ok, content} -> content
    end
  end
end
