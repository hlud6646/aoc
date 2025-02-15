defmodule Solutions.SolutionIXX do
  import Enum

  # This is another one where if you cannot cache it's a lot harder.
  def solve do
    {towels, arrangements} = read()

    arrangements
    |> count(fn arr ->
      {res, _} = count_solutions(arr, towels, %{})
      res > 0
    end)
  end

  def solve2 do
    {towels, arrangements} = read()

    arrangements
    |> map(fn arr ->
      {res, _} = count_solutions(arr, towels, %{})
      res
    end)
    |> sum
  end

  # ---
  # Simple version. Does not scale.
  def possible?("", _), do: true

  def possible?(arrangement, towels) do
    prefix_towels = towels |> filter(fn towel -> String.starts_with?(arrangement, towel) end)

    prefix_towels
    |> map(fn towel -> drop_prefix(arrangement, towel) end)
    |> any?(&possible?(&1, towels))
  end

  def drop_prefix(arrangment, towel) do
    n = String.length(towel)
    {_, rest} = String.split_at(arrangment, n)
    rest
  end

  # ---
  # Note: There is an optimization available for part1, where you can use Enum.reduce_while
  # in stead of reduce, and a boolean that represents whether the arrangement is possible
  # in place of the number that counts the solutions. It's fancy, and I hadn't seen 
  # reduce_while before, but this version is much better. 
  # Note also the nice separation of cache lookup and recursive hoo-ha into different
  # methods.
  def count_solutions(arrangement, towels, cache) do
    case Map.get(cache, arrangement) do
      nil -> run_count_solutions(arrangement, towels, cache)
      res -> {res, cache}
    end
  end

  defp(run_count_solutions("", _towels, cache), do: {1, cache})

  defp run_count_solutions(arrangement, towels, cache) do
    prefix_towels = towels |> filter(&String.starts_with?(arrangement, &1))

    if empty?(prefix_towels) do
      {0, Map.put(cache, arrangement, 0)}
    else
      reduce(
        prefix_towels,
        {0, cache},
        fn prefix_towel, {res, acc} ->
          {_, rest} = String.split_at(arrangement, String.length(prefix_towel))
          {new_res, new_cache} = count_solutions(rest, towels, acc)
          {res + new_res, Map.put(new_cache, arrangement, res + new_res)}
        end
      )
    end
  end

  # ---

  def read do
    path =
      Path.join([
        :code.priv_dir(:aoc),
        "static",
        "input",
        "19.txt"
      ])

    case File.read(path) do
      {:ok, contents} ->
        [towels, _ | arrangements] =
          contents
          |> String.split("\n")

        {towels |> String.split(", "), arrangements}
    end
  end
end
