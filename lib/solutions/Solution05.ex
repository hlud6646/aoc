defmodule Solution5 do
  import Enum
  import Util

  def solve() do
    {rules, updates} = read5()

    updates
    |> filter(&check_update(&1, rules))
    |> map(&middle_element/1)
    |> sum()
  end

  def solve2() do
    {rules, updates} = read5()

    Enum.filter(updates, fn update -> not check_update(update, rules) end)
    |> map(&fix(&1, rules))
    |> map(&middle_element/1)
    |> sum
  end

  defp read5() do
    rules =
      case File.read(Application.app_dir(:aoc, "priv/static/input/5_rules.txt")) do
        {:ok, content} ->
          lines(content)
          |> map(&String.split(&1, "|"))
          |> map(fn ln -> map(ln, &String.to_integer/1) end)
      end

    updates =
      case File.read(Application.app_dir(:aoc, "priv/static/input/5_updates.txt")) do
        {:ok, content} ->
          lines(content)
          |> map(&String.split(&1, ","))
          |> map(fn ln -> map(ln, &String.to_integer/1) end)
      end

    {rules, updates}
  end

  defp middle_element(xs) do
    at(xs, trunc((count(xs) - 1) / 2))
  end

  defp check(update, rule) do
    [l, r] = rule
    # If the update is missing the left or right part it automatically holds.
    if not (l in update and r in update) do
      true
      # Otherwise find the part of the update before l and make sure r is not there.
    else
      not member?(take(update, find_index(update, &(&1 == l))), r)
    end
  end

  defp violates?(update, rule) do
    not check(update, rule)
  end

  defp check_update(update, rules) do
    all?(rules, &check(update, &1))
  end

  defp shift(update, [l, r]) do
    u = List.delete(update, l)
    idx = Enum.find_index(u, &(&1 == r))
    List.insert_at(u, idx, l)
  end

  defp fix(update, rules) do
    case find(rules, &violates?(update, &1)) do
      nil -> update
      rule -> fix(shift(update, rule), rules)
    end
  end
end
