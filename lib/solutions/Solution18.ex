defmodule Solution18 do
  import Enum
  import Djikstra

  @moduledoc """

  ## What are we learning?
  Binary search!
  """

  @inf 999_999_999

  # Taking the first n bytes to fall, what is the length of a shortest path through the maze?
  defp f(n) do
    walls = read() |> take(n)

    {h, w} = {71, 71}

    unvisited = Util.product(0..(h - 1), 0..(w - 1))

    distance =
      unvisited
      |> into(%{}, fn x -> {x, @inf} end)
      |> Map.replace({0, 0}, 0)

    previous =
      unvisited
      |> into(%{}, fn x -> {x, nil} end)

    res =
      djikstra(
        unvisited |> into(MapSet.new()),
        distance,
        previous,
        fn u -> neighbours(u, walls) end
      )

    res
    |> find(fn {k, _} -> k == {70, 70} end)
    |> then(fn {_, distance} -> distance end)
  end

  def solve, do: f(1024)
  # What is the largest number of bytes that can fall while still allowing a path
  # through the maze?
  defp solve2(l, r) when r == l + 1 do
    l
  end

  # Binary search.
  defp solve2(l, r) do
    m = trunc(:math.floor((l + r) / 2))

    # f(m) will be less than infinity only if it is still possible to get to the end
    # after m bytes have fallen.
    case f(m) < @inf do
      true -> solve2(m, r)
      false -> solve2(l, m)
    end
  end

  # Don't forget that the answer wants xy but we have yx.
  def solve2 do
    # You can take n bytes and still get through the maze.
    n = solve2(2000, 3000)
    {y, x} = List.first(drop(read(), n))
    "#{x},#{y}"
  end

  defp neighbours({y, x}, walls) do
    {h, w} = {71, 71}

    [
      {y - 1, x},
      {y + 1, x},
      {y, x - 1},
      {y, x + 1}
    ]
    |> filter(fn {y_, x_} ->
      0 <= x_ and x_ < w and 0 <= y_ and y_ < h and not member?(walls, {y_, x_})
    end)
    |> map(fn v -> {v, 1} end)
  end

  def read do
    path = Application.app_dir(:aoc, "priv/static/input/18.txt")

    case File.read(path) do
      {:ok, contents} ->
        contents
        |> String.split("\n")
        |> map(fn s -> String.split(s, ",") |> map(&String.to_integer/1) |> then(&reverse/1) end)
        |> map(&List.to_tuple/1)
    end
  end
end
