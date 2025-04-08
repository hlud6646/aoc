defmodule Solution22 do
  @moduledoc """
  What are we learning?

  The process for finding the next secret number is ambiguous. Sometimes that
  will be the case and you'll have to spend some time figuring out what the
  question even is.
  """
  import Enum

  def solve do
    read() |> map(&twoThounsadthSecret/1) |> sum()
  end

  def solve2 do
    initialNumbers =
      read()

    read()
    |> map(fn n -> findSequence(prices(n), [-2, 1, 1, 3]) end)
    |> sum

    generateSequences(1)
    |> map(fn seq ->
      IO.inspect(seq)

      nBananas =
        initialNumbers
        |> map(fn n -> findSequence(prices(n), seq) end)
        |> sum

      IO.inspect(nBananas)
      nBananas
    end)
    |> max
  end

  # Mix a into b
  defp mix(a, b), do: Bitwise.bxor(a, b)
  defp prune(a), do: rem(a, 16_777_216)

  defp nextSecret(a) do
    x = prune(mix(a * 64, a))
    y = prune(mix(div(x, 32), x))
    prune(mix(y * 2048, y))
  end

  defp twoThounsadthSecret(a) do
    1..2000 |> reduce(a, fn _, acc -> nextSecret(acc) end)
  end

  # Part 2:

  # Return a list of {current price, last price change}
  defp prices(initialPrice) do
    p =
      initialPrice
      |> Stream.unfold(fn n -> {n, nextSecret(n)} end)
      |> Stream.map(&rem(&1, 10))

    delta = Stream.zip_with(Stream.drop(p, 1), p, &-/2)
    Stream.zip(Stream.drop(p, 1), delta)
  end

  defp findSequence(prices, sequence) do
    x =
      Stream.chunk_every(prices, 4, 1)
      |> Stream.take(2000)
      |> find(fn seq -> seq |> map(fn {_, d} -> d end) == sequence end)

    case x do
      [_, _, _, {p, _}] -> p
      nil -> 0
    end
  end

  def generateSequences(n) do
    for a <- -n..n, b <- -n..n, c <- -n..n, d <- -n..n do
      [a, b, c, d]
    end
  end

  defp read do
    path = Application.app_dir(:aoc, "priv/static/input/22.txt")

    case File.read(path) do
      {:ok, content} ->
        Util.lines(content)
        |> filter(&(String.length(&1) > 0))
        |> map(&String.to_integer/1)
    end
  end
end
