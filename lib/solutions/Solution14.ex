defmodule Solution14 do
  import Enum
  import Util

  @moduledoc """

  ## What have we learned?

  Sometimes questions are vague.
  """

  def read() do
    # TODO: This logic occurs in 13 also. Consider moving to util.
    extract_numbers = fn s ->
      Regex.scan(~r/(\-?\d+)/, s, capture: :all_but_first)
      |> then(&List.flatten/1)
      |> map(&String.to_integer/1)
    end

    path = Application.app_dir(:aoc, "priv/static/input/14.txt")

    case File.read(path) do
      {:ok, content} ->
        lines(content)
        |> map(extract_numbers)
        |> map(fn [x, y, vx, vy] -> {{x, y}, {vx, vy}} end)
    end
  end

  defp quadrant({x, y}) do
    if x == 50 or y == 51 do
      nil
    else
      case {x <= 49, y <= 50} do
        {true, true} -> 1
        {false, true} -> 2
        {false, false} -> 3
        {true, false} -> 4
      end
    end
  end

  def solve do
    read()
    |> map(fn {{x, y}, {vx, vy}} ->
      {Util.mod(x + 100 * vx, 101), Util.mod(y + 100 * vy, 103)}
    end)
    |> group_by(&quadrant/1)
    |> take(4)
    |> map(fn {_, v} -> count(v) end)
    |> product
  end

  def solve2 do
    {w, h} = {101, 103}

    step = fn robots ->
      robots
      |> map(fn {{x, y}, {vx, vy}} -> {{Util.mod(x + vx, w), Util.mod(y + vy, h)}, {vx, vy}} end)
    end

    show = fn robots ->
      grid = List.duplicate(List.duplicate(" ", w), h)

      reduce(robots, grid, fn {{x, y}, _}, grid ->
        List.update_at(grid, y, fn row ->
          List.update_at(row, x, fn _ -> "*" end)
        end)
      end)
      |> map(&join/1)
      |> then(&join(&1, "\n"))
    end

    # xmas? = fn robots ->
    #   # Most are in horizontal center?
    #   c = 11
    #   count(robots, fn {{x, _}, _} -> 50 - c < x and x < 50 + c end) / count(robots) >= 0.50

    # end

    # Print a bunch of them and try to spot an xmas tree.
    # Note that only times of the form 29 + 101k are printed, since I noticed when
    # printing all times that these seems to have extra structure.
    reduce(
      0..50000,
      read(),
      fn n, robots ->
        # if xmas?.(robots) do
        if rem(n - 29, 101) == 0 do
          IO.puts(
            "_________________________________________________________________________________________________________________"
          )

          IO.puts(to_string(n))
          IO.puts(show.(robots))

          IO.puts(
            "_________________________________________________________________________________________________________________"
          )

          IO.puts("\n\n\n")

          Process.sleep(100)
        end

        step.(robots)
      end
    )
  end
end
