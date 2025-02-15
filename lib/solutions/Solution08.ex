defmodule Solution8 do
  import Enum
  import Util
  import Grid

  def solve do
    grid = read()
    {h, w} = dims(grid)

    antinodes(find_antennas(read()))
    |> filter(fn {row, col} -> 0 <= row and row < h and 0 <= col and col < w end)
    |> then(&uniq/1)
    |> then(&count/1)
  end

  def solve2 do
    grid = read()
    {h, w} = dims(grid)

    antinodes2(find_antennas(grid), h, w)
    |> then(&uniq/1)
    |> then(&count/1)
  end

  defp read do
    path = Application.app_dir(:aoc, "priv/static/input/8.txt")

    case File.read(path) do
      {:ok, content} -> lines(content)
    end
  end

  # Given a pair of antennas, return the two antinodes.
  defp antinodes(u1, u2) do
    {y1, x1} = u1
    {y2, x2} = u2
    dy = y2 - y1
    dx = x2 - x1

    [
      {y2 + dy, x2 + dx},
      {y1 - dy, x1 - dx}
    ]
  end

  defp find_antennas(grid) do
    {h, w} = dims(grid)

    Util.product(0..(h - 1), 0..(w - 1))
    |> group_by(fn {row, col} -> String.at(at(grid, row), col) end)
    |> then(&Map.delete(&1, "."))
  end

  defp antinodes(antennas) do
    Map.values(antennas)
    |> flat_map(fn
      xs -> map(Util.pairs(xs), fn {u1, u2} -> antinodes(u1, u2) end)
    end)
    |> then(&List.flatten/1)
  end

  defp antinodes2(u1, u2, w, h) do
    {y1, x1} = u1
    {y2, x2} = u2
    dy = y2 - y1
    dx = x2 - x1

    part1 =
      Stream.unfold({y2, x2}, fn
        {row, col} -> {{row, col}, {row + dy, col + dx}}
      end)
      |> Stream.take_while(fn {row, col} -> 0 <= row and row < h and 0 <= col and col < w end)
      |> then(&to_list/1)

    part2 =
      Stream.unfold({y1, x1}, fn
        {row, col} -> {{row, col}, {row - dy, col - dx}}
      end)
      |> Stream.take_while(fn {row, col} -> 0 <= row and row < h and 0 <= col and col < w end)
      |> then(&to_list/1)

    part1 ++ part2
  end

  defp antinodes2(antennas, w, h) do
    Map.values(antennas)
    |> flat_map(fn
      xs -> map(Util.pairs(xs), fn {u1, u2} -> antinodes2(u1, u2, w, h) end)
    end)
    |> then(&List.flatten/1)
  end
end
