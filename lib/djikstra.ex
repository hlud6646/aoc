defmodule Djikstra do
  import Enum

  # This version does not terminate when it encounters the target.
  def djikstra(unvisited, distance, previous, neighbours) do
    if empty?(unvisited) do
      distance
    else
      u = min_by(unvisited, fn x -> distance[x] end)
      unvisited = unvisited |> MapSet.delete(u)

      updates =
        neighbours.(u)
        |> filter(fn {v, _} -> member?(unvisited, v) end)
        |> map(fn {v, edge_cost} -> {v, distance[u] + edge_cost} end)
        |> filter(fn {v, alt} -> alt < distance[v] end)

      distance = distance |> Map.merge(updates |> into(%{}))
      previous = previous |> Map.merge(updates |> map(fn {v, _cost} -> {v, u} end) |> into(%{}))

      djikstra(unvisited, distance, previous, neighbours)
    end
  end

  # This can be faster than the above.
  def djikstra(unvisited, distance, previous, neighbours, target) do
    if empty?(unvisited) do
      distance
    else
      u = min_by(unvisited, fn x -> distance[x] end)

      if u == target do
        distance
      else
        unvisited = unvisited |> MapSet.delete(u)

        updates =
          neighbours.(u)
          |> filter(fn v -> member?(unvisited, v) end)
          |> map(fn v -> {v, distance[u] + 1} end)
          |> filter(fn {v, alt} -> alt < distance[v] end)

        distance = distance |> Map.merge(updates |> into(%{}))
        previous = previous |> Map.merge(updates |> map(fn {v, _cost} -> {v, u} end) |> into(%{}))

        djikstra(unvisited, distance, previous, neighbours, target)
      end
    end
  end
end
