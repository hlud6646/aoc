defmodule Util do
  import Enum

  def lines(content) do
    String.split(content, "\n")
  end

  @doc """
  Return the cartesian product of two enumerables.
  """
  def product(x, y) do
    for xi <- x, yi <- y do
      {xi, yi}
    end
  end

  @doc """
  Return pairs of distinct elements in an enumerable.
  """
  def pairs(xs) do
    for x1 <- xs, x2 <- xs do
      {x1, x2}
    end
    |> filter(fn {x1, x2} -> x1 != x2 end)
  end

  @doc """
  Return the number of continuous runs of integers in a list.
  """
  def count_runs([]), do: 0
  def count_runs([_]), do: 1
  def count_runs(xs), do: count_runs(xs, List.first(xs) - 1)

  def count_runs([x], current) do
    if x == current + 1 do
      1
    else
      2
    end
  end

  def count_runs([head | tail], current) do
    if head == current + 1 do
      count_runs(tail, head)
    else
      1 + count_runs(tail, head)
    end
  end

  def inverse2(matrix) do
    [[a, b], [c, d]] = matrix
    det = a * d - b * c

    [[d, -b], [-c, a]]
    |> map(fn row -> map(row, fn x -> x / det end) end)
  end

  def mod(n, d) do
    case rem(n, d) do
      r when r < 0 -> r + d
      r -> r
    end
  end
end

# Primitive testing...
unless Util.count_runs([]) == 0, do: raise("Expected Util.count_runs([]) to return 0")
unless Util.count_runs([42]) == 1, do: raise("Expected Util.count_runs([42]) to return 1")
unless Util.count_runs([42, 42]) == 2, do: raise("Expected Util.count_runs([42, 42]) to return 2")
unless Util.count_runs([42, 69]) == 2, do: raise("Expected Util.count_runs([42, 69]) to return 2")
unless Util.count_runs([42, 43]) == 1, do: raise("Expected Util.count_runs([42, 43]) to return 1")

unless Util.count_runs([42, 43, 44]) == 1,
  do: raise("Expected Util.count_runs([42, 43, 44]) to return 1")

unless Util.count_runs([42, 43, 49]) == 2,
  do: raise("Expected Util.count_runs([42, 43, 49]) to return 2")

unless Util.count_runs([17, 43, 44]) == 2,
  do: raise("Expected Util.count_runs([17, 43, 44]) to return 2")
