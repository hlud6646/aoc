defmodule Solution20 do
  import Enum
  import Grid

  # Set to :example or :main.
  @mode :example

  def solve do
    grid = read()
    {start, target, walls} = find_initial_config(grid)
    path = walk([start], target, walls, dims(grid)) |> then(&reverse/1)
    path = with_index(path)

    tails(path)
    |> map(&find_current_cheats/1)
    |> then(&List.flatten/1)
    |> group_by(fn x -> x end)
    |> map(fn {k, v} -> {k, length(v)} end)

    # |> filter(fn {saving, count} -> saving >= 100 end)
    # |> map(fn {_saving, count} -> count end)
    # |> sum
  end

  # Cheat on the current position.
  defp find_current_cheats([{current_position, current_time} | rest]) do
    IO.puts(current_time)
    {current_y, current_x} = current_position

    rest
    |> filter(fn {{later_y, later_x}, _} ->
      any?([
        later_x == current_x + 2 and later_y == current_y,
        later_x == current_x - 2 and later_y == current_y,
        later_y == current_y + 2 and later_x == current_x,
        later_y == current_y - 2 and later_x == current_x
      ])
    end)
    # |> map(fn later -> {current, later} end)
    |> map(fn {_, later_time} -> later_time - current_time - 2 end)
  end

  # A list of all the tails of a list.
  defp tails([]), do: []
  defp tails([_]), do: []
  defp tails([_ | xs]), do: [xs | tails(xs)]

  # Keep walking along the path, until you hit the target.
  defp walk(path, target, walls, {h, w}) do
    current = List.first(path)
    next = Enum.find(one_step(current, walls, {h, w}), fn v -> v != at(path, 1) end)

    if next == target do
      [target | path]
    else
      walk([next | path], target, walls, {h, w})
    end
  end

  defp one_step(current, walls, {h, w}) do
    {y, x} = current

    [
      {y - 1, x},
      {y + 1, x},
      {y, x - 1},
      {y, x + 1}
    ]
    |> filter(fn {y_, x_} ->
      0 <= x_ and
        x_ < w and
        0 <= y_ and
        y_ < h and
        not member?(walls, {y_, x_})
    end)
  end

  defp read do
    path =
      case @mode do
        :example -> Application.app_dir(:aoc, "priv/static/input/20.example.txt")
        :main -> Application.app_dir(:aoc, "priv/static/input/20.txt")
      end

    case File.read(path) do
      {:ok, contents} ->
        contents
        |> String.split("\n")
        |> filter(&(String.length(&1) > 0))
    end
  end
end
