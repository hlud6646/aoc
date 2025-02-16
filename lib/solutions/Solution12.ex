defmodule Solution12 do
  import Enum
  import Grid
  import Util

  def solve() do
    f12(fn region -> count(boundary(region)) * count(region) end)
  end

  def solve2() do
    f12(fn region -> count_sides(region) * count(region) end)
  end

  def read do
    path = Application.app_dir(:aoc, "priv/static/input/12.txt")

    case File.read(path) do
      {:ok, content} -> lines(content) |> map(&String.graphemes/1)
    end
  end

  defp connected_plots(to_visit, garden, visited \\ MapSet.new())

  defp connected_plots([], _, visited), do: visited

  defp connected_plots([{row, col} | rest], garden, visited) do
    {h, w} = dims(garden)

    in_range? = fn
      {row, col} -> 0 <= row and row < w and 0 <= col and col < h
    end

    plot_type = at(at(garden, row), col)

    new_plots =
      [{row, col - 1}, {row, col + 1}, {row - 1, col}, {row + 1, col}]
      |> filter(fn {i, j} ->
        in_range?.({i, j}) and
          at(at(garden, i), j) == plot_type and
          not MapSet.member?(visited, {i, j})
      end)

    connected_plots(uniq(new_plots ++ rest), garden, MapSet.put(visited, {row, col}))
  end

  defp add_region({row, col}, garden, regions) do
    case regions[{row, col}] do
      nil ->
        regionid = Enum.max(Map.values(regions), _empty_fallback = fn -> 0 end) + 1

        connected_plots([{row, col}], garden)
        |> Map.new(fn {row, col} -> {{row, col}, regionid} end)
        |> Map.merge(regions)

      _ ->
        regions
    end
  end

  defp regions(garden) do
    {h, w} = dims(garden)

    reduce(
      Util.product(0..(h - 1), 0..(w - 1)),
      Map.new(),
      &add_region(&1, garden, &2)
    )
    |> group_by(fn {_, v} -> v end)
    |> then(&Map.values/1)
    |> map(fn region -> region |> map(fn {pos, _} -> pos end) end)
  end

  # Compute the edges of a plot.
  # Each edge is represented as a tuple of {y, x, orientation}.
  defp edges({row, col}) do
    {i, j} = {2 * row, 2 * col}

    [
      # Top edge (faces down)
      {i - 1, j, 0},
      # Right edge (faces left)
      {i, j + 1, 0},
      #
      {i + 1, j, 1},
      #
      {i, j - 1, 1}
    ]
  end

  # Compute the oriented boundary of a region.
  defp boundary(region) do
    region
    |> flat_map(&edges/1)
    |> group_by(fn {y, x, _} -> {y, x} end)
    |> then(&Map.values/1)
    |> filter(&(count(&1) == 1))
    |> then(&List.flatten/1)
  end

  defp count_sides(region) do
    f = fn edges ->
      edges
      |> group_by(fn {a, _, c} -> {a, c} end)
      |> then(&Map.values/1)
      |> map(fn z -> sort(map(z, fn {_, b, _} -> div(b, 2) end)) end)
      |> map(&Util.count_runs/1)
      |> sum
    end

    # Vertical and horizontal edges
    {vs, hs} =
      boundary(region)
      |> split_with(fn {fst, _, _} -> rem(fst, 2) == 0 end)

    vs = map(vs, fn {a, b, c} -> {b, a, c} end)

    f.(vs) + f.(hs)
  end

  # Find the sum of scores for all regions, given a scoring function.
  defp f12(score) do
    read()
    |> filter(&(count(&1) > 0))
    |> then(&regions/1)
    |> map(score)
    |> sum
  end
end
