defmodule Solutions.Solution18 do
  import Enum

  # Taking the first n bytes to fall, what is the length of a shortest path through the maze?
  def solve(n \\ 1024) do
    infinity = 10 ** 10
    walls = read() |> take(n)

    {h, w} = {71, 71}

    unvisited = Util.product(0..(h - 1), 0..(w - 1))

    distance =
      unvisited
      |> into(%{}, fn x -> {x, infinity} end)
      |> Map.replace({0, 0}, 0)

    previous =
      unvisited
      |> into(%{}, fn x -> {x, nil} end)

    djikstra(unvisited |> into(MapSet.new()), distance, previous, walls, {70, 70})
    |> find(fn {k, _} -> k == {70, 70} end)
    |> then(fn {_, distance} -> distance end)
  end

  # What is the largest number of bytes that can fall while still allowing a path
  # through the maze?
  def solve2(l, r) when r == l + 1 do
    l
  end

  # Binary search.
  def solve2(l, r) do
    infinity = 10 ** 10
    m = trunc(:math.floor((l + r) / 2))

    case solve(m) < infinity do
      true -> solve2(m, r)
      false -> solve2(l, m)
    end
  end

  # Don't forget that the answer wants xy but we have yx.
  def solve2 do
    # You can take n bytes and still get through the maze.
    n = solve2(2000, 3000)
    List.first(drop(read(), n))
  end

  # Find the length of the shortest path to the target.
  def djikstra(unvisited, distance, previous, walls, target) do
    if empty?(unvisited) do
      distance
    else
      u = min_by(unvisited, fn x -> distance[x] end)

      if u == target do
        distance
      else
        unvisited = unvisited |> MapSet.delete(u)

        updates =
          neighbours(u, walls)
          |> filter(fn v -> member?(unvisited, v) end)
          |> map(fn v -> {v, distance[u] + 1} end)
          |> filter(fn {v, alt} -> alt < distance[v] end)

        distance = distance |> Map.merge(updates |> into(%{}))
        previous = previous |> Map.merge(updates |> map(fn {v, _cost} -> {v, u} end) |> into(%{}))

        djikstra(unvisited, distance, previous, walls, target)
      end
    end
  end

  def neighbours(u, walls) do
    {h, w} = {71, 71}

    {y, x} = u

    [
      {y - 1, x},
      {y + 1, x},
      {y, x - 1},
      {y, x + 1}
    ]
    |> filter(fn {y_, x_} ->
      0 <= x_ and x_ < w and 0 <= y_ and y_ < h and not member?(walls, {y_, x_})
    end)
  end

  def read do
    path =
      Path.join([
        :code.priv_dir(:aoc),
        "static",
        "input",
        "18.txt"
      ])

    case File.read(path) do
      {:ok, contents} ->
        contents
        |> String.split("\n")
        |> map(fn s -> String.split(s, ",") |> map(&String.to_integer/1) |> then(&reverse/1) end)
        |> map(&List.to_tuple/1)
    end
  end
end
