defmodule Solution15 do
  import Enum
  import Util

  def solve do
    {grid, moves} = read()
    grid = reduce(moves, grid, &update/2)

    # GPS
    {h, w} = Grid.dims(grid)

    grid
    |> map(fn row -> filter(1..w, fn i -> String.at(row, i) == "O" end) end)
    |> drop(1)
    |> take(h - 2)
    |> zip(100..(100 * h)//100)
    |> map(fn {xs, y} -> sum(map(xs, &(y + &1))) end)
    |> sum
  end

  def read do
    grid =
      case File.read(Application.app_dir(:aoc, "priv/static/input/15_grid.txt")) do
        {:ok, content} -> lines(content)
      end

    moves =
      case File.read(Application.app_dir(:aoc, "priv/static/input/15_moves.txt")) do
        {:ok, content} -> content |> String.replace("\n", "") |> then(&String.graphemes/1)
      end

    {grid, moves}
  end

  defp update_row(row) do
    # Robot has empty space in front.
    if String.contains?(row, "@.") do
      String.replace(row, "@.", ".@")
    else
      # Robot has blocks followed by empty space in front.
      # If this is not found, then return the row unchanged.
      Regex.replace(~r/@(O+)\./, row, fn _, blocks -> ".@#{blocks}" end)
    end
  end

  # You only really need to implement an update function for the > motion.
  # The other directions correspond to an update on a modified grid.
  defp update(direction, grid) do
    robot_row = find_index(grid, &String.contains?(&1, "@"))

    case direction do
      "<" -> Grid.reflect(update(">", Grid.reflect(grid)))
      "^" -> Grid.rotate_left(update(">", Grid.rotate_right(grid)))
      "v" -> Grid.rotate_right(update(">", Grid.rotate_left(grid)))
      ">" -> grid |> List.update_at(robot_row, &update_row/1)
    end
  end
end
