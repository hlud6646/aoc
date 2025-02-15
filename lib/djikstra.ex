defmodule Djikstra do
  # import Enum

  # # Many of these problems have a (S)tart, an (E)nd and some walls.
  # def find_initial_config(grid) do
  #   startPos = grid |> Grid.find(&(&1 == "S")) |> then(&List.first/1)
  #   endPos = grid |> Grid.find(&(&1 == "E")) |> then(&List.first/1)
  #   walls = Grid.find(grid, &(&1 == "#"))
  #   {startPos, endPos, walls}
  # end

  # # This version does not terminate when it encounters the target.
  # # TODO: This should be a private helper, and there shold be a public method like
  # # def djikstra(grid) which calls it.
  # def djikstra(unvisited, distance, previous, walls, height, width) do
  #   if empty?(unvisited) do
  #     distance
  #   else
  #     u = min_by(unvisited, fn x -> distance[x] end)
  #     unvisited = unvisited |> MapSet.delete(u)

  #     updates =
  #       neighbours(u, walls, height, width)
  #       |> filter(fn {v, _} -> member?(unvisited, v) end)
  #       |> map(fn {v, edge_cost} -> {v, distance[u] + edge_cost} end)
  #       |> filter(fn {v, alt} -> alt < distance[v] end)

  #     distance = distance |> Map.merge(updates |> into(%{}))
  #     previous = previous |> Map.merge(updates |> map(fn {v, _cost} -> {v, u} end) |> into(%{}))

  #     djikstra(unvisited, distance, previous, walls, height, width)
  #   end
  # end

  # # This can be faster than the above.
  # def djikstra(unvisited, distance, previous, walls, target, height, width) do
  #   if empty?(unvisited) do
  #     distance
  #   else
  #     u = min_by(unvisited, fn x -> distance[x] end)

  #     if u == target do
  #       distance
  #     else
  #       unvisited = unvisited |> MapSet.delete(u)

  #       updates =
  #         neighbours(u, walls, height, width)
  #         |> filter(fn v -> member?(unvisited, v) end)
  #         |> map(fn v -> {v, distance[u] + 1} end)
  #         |> filter(fn {v, alt} -> alt < distance[v] end)

  #       distance = distance |> Map.merge(updates |> into(%{}))
  #       previous = previous |> Map.merge(updates |> map(fn {v, _cost} -> {v, u} end) |> into(%{}))

  #       djikstra(unvisited, distance, previous, walls, target, height, width)
  #     end
  #   end
  # end

  # def neighbours(u, walls, height, width) do

  #   {y, x} = u

  #   [
  #     {y - 1, x},
  #     {y + 1, x},
  #     {y, x - 1},
  #     {y, x + 1}
  #   ]
  #   |> filter(fn {y_, x_} ->
  #     0 < x_ and x_ < width and 0 < y_ and y_ < height and not member?(walls, {y_, x_})
  #   end)
  # end
end
