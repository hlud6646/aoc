defmodule Grid do
  @moduledoc """
  Useful functions for working with a 2d grid.
  A grid should be a list of lists, or a list of strings.
  """

  import Enum

  def dims([]), do: {0, 0}

  def dims(grid) do
    h = count(grid)

    cond do
      is_list(at(grid, 0)) -> {h, count(at(grid, 0))}
      is_binary(at(grid, 0)) -> {h, String.length(at(grid, 0))}
    end
  end

  def find(grid, predicate) do
    {h, w} = dims(grid)

    Util.product(0..(h - 1), 0..(w - 1))
    |> filter(fn {row, col} ->
      cond do
        is_list(at(grid, 0)) -> predicate.(at(at(grid, row), col))
        is_binary(at(grid, 0)) -> predicate.(String.at(at(grid, row), col))
      end
    end)
  end

  def reflect([]), do: []

  def reflect(grid) do
    cond do
      is_list(at(grid, 0)) -> grid |> map(&reverse/1)
      is_binary(at(grid, 0)) -> grid |> map(&String.reverse/1)
    end
  end

  def transpose(grid) when length(grid) == 0, do: []

  def transpose(grid) do
    cond do
      is_list(at(grid, 0)) ->
        0..(length(at(grid, 0)) - 1)
        |> map(fn i -> map(grid, &at(&1, i)) end)

      is_binary(at(grid, 0)) ->
        grid
        |> map(&String.graphemes/1)
        |> transpose()
        |> map(&Enum.join/1)
    end
  end

  def flip(grid) do
    map(grid, &reverse/1)
  end

  def diagonals(grid) do
    {h, w} = dims(grid)

    for k <- -(h - 1)..(w - 1) do
      for i <- 0..(h - 1),
          j <- 0..(w - 1),
          i - j == k,
          i < h,
          j < w do
        at(at(grid, i), j)
      end
    end
    |> Enum.filter(&(length(&1) > 0))
  end

  def _columns_list([]), do: []

  def _columns_list(grid) do
    h = count(grid)
    w = count(at(grid, 0))

    col = fn i ->
      for j <- 0..(h - 1) do
        at(at(grid, j), i)
      end
    end

    0..(w - 1) |> map(col)
  end

  def columns([]), do: []

  def columns(grid) do
    cond do
      is_list(at(grid, 0)) ->
        _columns_list(grid)

      is_binary(at(grid, 0)) ->
        grid |> map(&String.graphemes/1) |> then(&columns/1) |> map(&join/1)
    end
  end

  def rotate_right(grid) do
    cond do
      is_list(at(grid, 0)) -> columns(grid) |> map(&reverse/1)
      is_binary(at(grid, 0)) -> columns(grid) |> map(&String.reverse/1)
    end
  end

  def rotate_left(grid), do: columns(grid) |> then(&reverse/1)

  def show(grid) do
    cond do
      is_list(at(grid, 0)) ->
        grid
        |> map(fn row -> join(map(row, &to_string/1)) end)
        |> then(&show/1)

      is_binary(at(grid, 0)) ->
        w = String.length(at(grid, 0))
        lid = "+" <> join(List.duplicate("-", w)) <> "+"

        grid
        |> map(fn row -> "|" <> row <> "|" end)
        |> then(fn rows -> [lid | rows] ++ [lid] end)
        |> join("\n")
        # |> then(&IO.puts("\n" <> &1 <> "\n"))
        |> then(&IO.puts/1)
    end
  end
end
