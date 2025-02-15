defmodule Solution11 do
  import Enum

  @moduledoc """
  Solution for Day 11 of Advent of Code.

  ## What are we learning?

  Function caching can be useful for problems like this, but is not easy
  in functional languages. In python, you can simply write your recursive
  function and decorate it with the `@lur_cache()`.
  In Elixir, you have to manually manage a cache. See below for an implementation
  spun up by an LLM.

  TODO: How do you implement this using the state monad in Haskell, and what is a
  similar pattern in elixir?
  """

  def solve() do
    "1117 0 8 21078 2389032 142881 93 385"
    |> then(&String.split/1)
    |> map(&count_stones(&1, 25))
    |> sum
  end

  defp count_stones(_, 0) do
    1
  end

  defp count_stones(stone, blinks) do
    cond do
      stone == "0" ->
        count_stones("1", blinks - 1)

      rem(String.length(stone), 2) == 0 ->
        {l, r} = String.split_at(stone, div(String.length(stone), 2))
        [l, r] = [l, r] |> map(fn s -> to_string(String.to_integer(s)) end)
        count_stones(l, blinks - 1) + count_stones(r, blinks - 1)

      true ->
        count_stones(to_string(String.to_integer(stone) * 2024), blinks - 1)
    end
  end

  # Part 2 using erlang term storage.

  def solve2() do
    :ets.new(:stones_cache, [:set, :public, :named_table])

    result =
      "1117 0 8 21078 2389032 142881 93 385"
      |> then(&String.split/1)
      |> map(&count_stones_cached(&1, 75))
      |> sum

    :ets.delete(:stones_cache)
    result
  end

  defp count_stones_cached(stone, blinks) do
    case :ets.lookup(:stones_cache, {stone, blinks}) do
      [{_, result}] ->
        result

      [] ->
        result = calculate_stones_cached(stone, blinks)
        :ets.insert(:stones_cache, {{stone, blinks}, result})
        result
    end
  end

  defp calculate_stones_cached(_, 0) do
    1
  end

  # As above, but using the cache.
  defp calculate_stones_cached(stone, blinks) do
    cond do
      stone == "0" ->
        count_stones_cached("1", blinks - 1)

      rem(String.length(stone), 2) == 0 ->
        {l, r} = String.split_at(stone, div(String.length(stone), 2))
        [l, r] = [l, r] |> map(fn s -> to_string(String.to_integer(s)) end)
        count_stones_cached(l, blinks - 1) + count_stones_cached(r, blinks - 1)

      true ->
        count_stones_cached(to_string(String.to_integer(stone) * 2024), blinks - 1)
    end
  end
end
