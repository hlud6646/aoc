defmodule Solution16 do
  import Enum
  import Djikstra
  import Grid

  # TODO: Use a module level declarations for the example/full set and use conditionals based on
  # this variable to determine grid size (i.e. instead of a hardcoded n=15 and n=101 all over the
  # place you could have a single data = :test and then if data == :test then n == 15)

  defp read do
    path = Application.app_dir(:aoc, "priv/static/input/16.txt")

    case File.read(path) do
      {:ok, contents} ->
        contents
        |> String.split("\n")
        |> filter(&(String.length(&1) > 0))
    end
  end

  def write(solution) do
    path = Application.app_dir(:aoc, "priv/static/output/16.txt")

    file = File.stream!(path)

    solution
    |> Stream.map(fn {{{y, x}, dir}, cost} -> "#{x},#{y},#{dir},#{cost}\n" end)
    |> Stream.into(file)
    |> Stream.run()
  end

  def solve do
    n = 139
    # n = 15
    grid = read()
    {startPos, end_pos, walls} = find_initial_config(grid)

    unvisited = Util.product(Util.product(1..n, 1..n), [">", "v", "<", "^"])

    distance = unvisited |> into(Map.new(), fn x -> {x, :infinity} end)
    previous = unvisited |> into(Map.new(), fn x -> {x, nil} end)
    distance = distance |> Map.replace({startPos, ">"}, 0)

    solution =
      djikstra(
        unvisited |> into(MapSet.new()),
        distance,
        previous,
        fn u -> neighbours(u, walls) end
      )

    write(solution)

    solution
    |> filter(fn {{pos, _}, _} -> pos == end_pos end)
    |> min_by(fn {_, cost} -> cost end)
    |> elem(1)
  end

  # Given this position and direction, return a list of all the adjacent positions with the
  # associated cost to get there (1000 for a rotation and 1 for a step.).
  # These are not validated, so may be outside the grid or may conincide with a wall.
  defp _moves(pos, dir) do
    {y, x} = pos

    rotations =
      case dir do
        "^" -> ["<", ">"]
        ">" -> ["^", "v"]
        "v" -> ["<", ">"]
        "<" -> ["v", "^"]
      end
      |> map(fn d -> {{pos, d}, 1000} end)

    step =
      case dir do
        "^" -> {{{y - 1, x}, "^"}, 1}
        ">" -> {{{y, x + 1}, ">"}, 1}
        "v" -> {{{y + 1, x}, "v"}, 1}
        "<" -> {{{y, x - 1}, "<"}, 1}
      end

    [step | rotations]
  end

  # Given a position and direction and the location of all the walls, return a list of valid moves.
  # Note that this is part of the setup to apply Djikstra's algorithm. The nodes in that algo
  # will be {pos, dir} tuples.
  defp neighbours(u, walls) do
    {pos, dir} = u
    n = 139
    # n = 15

    _moves(pos, dir)
    |> filter(fn {{pos, _dir}, _cost} -> not member?(walls, pos) end)
    |> filter(fn {{{y, x}, _dir}, _cost} -> 1 <= x and x <= n and 1 <= y and y <= n end)
  end

  #   def read2 do
  #     path =
  #       Path.join([
  #         :code.priv_dir(:aoc),
  #         "static",
  #         "output",
  #         "16full.txt"
  #       ])

  #     case File.read(path) do
  #       {:ok, contents} ->
  #         contents
  #         |> String.split("\n")
  #         |> filter(&(String.length(&1) > 0))
  #         |> map(&String.split(&1, ","))
  #         |> map(fn [x, y, dir, cost] ->
  #           {{{String.to_integer(y), String.to_integer(x)}, dir}, String.to_integer(cost)}
  #         end)
  #         |> into(%{})
  #     end
  #   end

  #   def _moves_reversed(pos, dir) do
  #     {y, x} = pos

  #     rotations =
  #       case dir do
  #         "^" -> ["<", ">"]
  #         ">" -> ["^", "v"]
  #         "v" -> ["<", ">"]
  #         "<" -> ["v", "^"]
  #       end
  #       |> map(fn d -> {{pos, d}, 1000} end)

  #     step =
  #       case dir do
  #         "^" -> {{{y + 1, x}, "^"}, 1}
  #         ">" -> {{{y, x - 1}, ">"}, 1}
  #         "v" -> {{{y - 1, x}, "v"}, 1}
  #         "<" -> {{{y, x + 1}, "<"}, 1}
  #       end

  #     [step | rotations]
  #   end

  #   def neighbours_reversed(u, best) do
  #     {pos, dir} = u
  #     n = 139
  #     # n = 15

  #     _moves_reversed(pos, dir)
  #     |> filter(fn {{{y, x}, _dir}, _cost} -> 1 <= x and x <= n and 1 <= y and y <= n end)
  #     |> filter(fn {v, cost} -> best[v] == best[u] - cost end)
  #     |> map(fn {k, _} -> k end)
  #   end

  #   def paths(u, best) do
  #     n = 139
  #     # n = 15
  #     {pos, _dir} = u

  #     if pos == {n, 1} do
  #       [[u]]
  #     else
  #       neighbours_reversed(u, best)
  #       |> flat_map(fn v -> paths(v, best) |> map(fn rest -> [v | rest] end) end)
  #     end
  #   end

  #   def solve2 do
  #     n = 139
  #     # n = 15
  #     best = read2()

  #     {end_pos, _} =
  #       best
  #       |> filter(fn {{pos, _dir}, _cost} -> pos == {1, n} end)
  #       |> min_by(fn {{_pos, _dir}, cost} -> cost end)

  #     paths(end_pos, best)
  #     |> then(&List.flatten/1)
  #     |> map(fn {pos, _dir} -> pos end)
  #     |> uniq
  #     |> count
  #     |> then(&IO.inspect/1)
  #   end
end
