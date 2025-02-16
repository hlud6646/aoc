defmodule Solution13 do
  import Enum
  import Util

  @moduledoc """

  What have we learned?

  """

  def solve() do
    read()
    |> map(fn [[xa, ya], [xb, yb], [x, y]] -> solve_2d_system(xa, xb, ya, yb, x, y) end)
    |> filter(fn {na, nb} ->
      abs(na - round(na)) < 0.001 and
        abs(nb - round(nb)) < 0.001 and
        0 <= na and
        0 <= nb and
        na <= 100 and
        nb <= 100
    end)
    |> map(fn {na, nb} -> 3 * round(na) + round(nb) end)
    |> sum
  end

  def solve2() do
    read()
    |> map(fn [a, b, [x, y]] -> [a, b, [x + 10_000_000_000_000, y + 10_000_000_000_000]] end)
    |> map(fn [[xa, ya], [xb, yb], [x, y]] -> solve_2d_system(xa, xb, ya, yb, x, y) end)
    |> filter(fn {na, nb} ->
      abs(na - round(na)) < 0.001 and
        abs(nb - round(nb)) < 0.001 and
        0 <= na and
        0 <= nb
    end)
    |> map(fn {na, nb} -> 3 * round(na) + round(nb) end)
    |> sum
  end

  def read do
    path = Application.app_dir(:aoc, "priv/static/input/13.txt")

    extract_numbers = fn s ->
      Regex.scan(~r/(\d+)/, s, capture: :all_but_first)
      |> then(&List.flatten/1)
      |> map(&String.to_integer/1)
    end

    case File.read(path) do
      {:ok, content} ->
        lines(content)
        |> chunk_every(3, 4)
        |> map(&map(&1, extract_numbers))
    end
  end

  # Solve the system of linear equations x = xa + xb, y = ya + yb.
  defp solve_2d_system(xa, xb, ya, yb, x, y) do
    matrix = [[xa, xb], [ya, yb]]
    [[z1, z2], [w1, w2]] = Util.inverse2(matrix)

    {
      z1 * x + z2 * y,
      w1 * x + w2 * y
    }
  end
end
