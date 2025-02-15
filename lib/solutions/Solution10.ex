defmodule Solution10 do
  import Enum
  import Util
  import Grid

  @moduledoc """
  Solution for Day 10 of Advent of Code.

  What are we learning?
    We need an algo to count the number of paths from 0 to 9 for each 0.
    The obvious interim solution is an algo that counts paths from each digit to 9, whether
    it be a 0 or some other number. The question is, how much info should we keep track of?
    Recording all paths is too much, since we don't actually care about the path, just the number
    of paths.
    Recording the number of reachable 9s from a given 6 (say) is not enough, since you'll get
    double counting.
    The right thing to record is the set of reachable 9s from this 6.
    Then the reachable 9s from some 5 is the union of reachable 9s from all 6s in range of
    this 5.
    So what we have learnt is that in algo design, figure out the MINIMAL content that needs to
    be recorded to get to the answer.

  """

  def solve do
    grid = read()

    {h, w} = dims(grid)

    # Find the eights and record the reachable nines.
    eights =
      Util.product(0..(h - 1), 0..(w - 1))
      |> filter(fn v -> get_height(v, grid) == 8 end)
      |> Map.new(fn v -> {v, step_up(v, grid)} end)

    # TODO: Rename and document this function.
    go = fn height, above ->
      Util.product(0..(h - 1), 0..(w - 1))
      |> filter(fn v -> get_height(v, grid) == height end)
      |> Map.new(fn v ->
        {v, step_up(v, grid) |> flat_map(fn next -> Map.fetch!(above, next) end) |> uniq}
      end)
    end

    reduce(7..0//-1, eights, go)
    |> then(&Map.values/1)
    |> map(&count/1)
    |> then(&sum/1)
  end

  def solve2 do
    grid = read()

    {h, w} = dims(grid)

    Util.product(0..(h - 1), 0..(w - 1))
    |> filter(fn v -> get_height(v, grid) == 0 end)
    |> map(&n_trails(&1, grid))
    |> then(&sum/1)
  end

  defp get_height({row, col}, grid) do
    at(at(grid, row), col)
  end

  defp adjacent({row, col}, grid) do
    {h, w} = dims(grid)

    [{row - 1, col}, {row + 1, col}, {row, col - 1}, {row, col + 1}]
    |> filter(fn {i, j} -> 0 <= i and i < h and 0 <= j and j < w end)
  end

  defp step_up(v, grid) do
    adjacent(v, grid) |> filter(&(get_height(&1, grid) == get_height(v, grid) + 1))
  end

  defp n_trails(v, grid) do
    case get_height(v, grid) do
      9 -> 1
      _ -> step_up(v, grid) |> map(&n_trails(&1, grid)) |> sum
    end
  end

  defp read do
    path = Application.app_dir(:aoc, "priv/static/input/10.txt")

    case File.read(path) do
      {:ok, content} ->
        lines(content) |> map(fn row -> map(String.graphemes(row), &String.to_integer/1) end)
    end
  end
end
