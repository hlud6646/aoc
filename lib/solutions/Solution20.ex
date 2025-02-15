defmodule Solutions.Solution20 do
  import Enum
  # import Djikstra

  def solve do
    _grid = read()
    # {height, width} = Grid.dims(grid)
    # {start, target, walls} = find_initial_config(grid)
  end

  defp read do
    path =
      Path.join([
        :code.priv_dir(:aoc),
        "static",
        "input",
        "20.txt"
      ])

    case File.read(path) do
      {:ok, contents} ->
        contents
        |> String.split("\n")
        |> filter(&(String.length(&1) > 0))
    end
  end
end
