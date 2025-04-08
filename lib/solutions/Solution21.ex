defmodule Solution21 do
  import Enum

  # def solve do
  # end

  # def solve2 do
  # end

  # defp read do
  # end


  defp numberpad do
    [
      ["7", "8", "9"],
      ["4", "5", "6"],
      ["1", "2", "3"],
      ["X", "0", "A"]
    ]
  end

  defp neighbours(key) do
    {row, y} = numberpad()
      |> with_index
      |> find(fn {row, _} -> Enum.find(row, &(&1==key)) end)

    x = row |> with_index |> find(fn {c, _} -> c==key end) |> elem(1)

    [{y-1,x, "^"}, {y+1,x, "v"}, {y,x-1, "<"}, {y,x+1, ">"}]
    |> filter(fn {y,x, _} -> x >= 0 and x <= 2 and y >= 0 and y <= 3 end)
    |> map(fn {y,x, dir} -> {numberpad() |> at(y) |> at(x), dir} end)
    |> filter(fn {k, _} -> k != "X" end)
  end


  # OK writing a recursive algo without types is a HORROR SHOW
  def paths_from(key, visited) do

    # Take the neighbours of the key, and filter by unvisited.
    #
    # return the path to that key, and any continuations of that path.
    #

    ns = neighbours(key)
      |> filter(fn {next_key, _} -> not member?(visited, next_key) end)


    # Paths from the start key to the neighour.
    short_paths = ns |> map( fn next -> [next, {key, ""}] end )

    # Extensions of these paths.
    long_paths = short_paths
    |> map(fn [head | tail] ->
      {current_key, _} = head
      paths_from(current_key, [current_key | visited])
      |> map(fn path -> path ++ tail end)
    end)

    short_paths ++ long_paths

  end

end
