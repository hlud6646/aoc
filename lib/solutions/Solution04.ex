defmodule Solution4 do
  import Enum
  import Grid

  # Note: The solution for part 2 is better, and would handle this part more easily too.
  # Leaving this one here to show a different approach.
  def solve do
    grid = read4()

    count_xmas_horizontal(grid) +
      count_xmas_horizontal(transpose(grid)) +
      count_xmas_horizontal(diagonals(grid)) +
      count_xmas_horizontal(diagonals(flip(grid)))
  end

  def solve2 do
    grid = read4()
    w = count(at(grid, 0))

    for rows <- chunk_every(grid, 3, 1, :discard), i <- 0..(w - 3) do
      map(rows, fn row -> slice(row, i..(i + 2)) end)
      |> then(&List.flatten/1)
      |> then(&to_string/1)
    end
    |> count(&Regex.match?(~r/(M.S.A.M.S|S.S.A.M.M|M.M.A.S.S|S.M.A.S.M)/, &1))
  end

  defp read4 do
    path = Application.app_dir(:aoc, "priv/static/input/4.txt")

    case File.read(path) do
      {:ok, content} -> map(String.split(content), &String.graphemes/1)
    end
  end

  defp count_xmas_row(row) do
    count(Regex.scan(~r/(?=(XMAS|SAMX))/, to_string(row), capture: :all_but_first))
  end

  defp count_xmas_horizontal(grid) do
    map(grid, &count_xmas_row/1) |> sum
  end
end
