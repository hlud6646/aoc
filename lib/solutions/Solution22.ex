defmodule Solution22 do
  # import Enum

  def solve do
    read() |> Enum.map(&twoThounsadthSecret/1) |> Enum.sum()
  end

  # def solve2 do
  # end

  # Mix a into b
  defp mix(a, b), do: Bitwise.bxor(a, b)
  defp prune(a), do: rem(a, 16_777_216)

  defp nextSecret(a) do
    x = prune(mix(a * 64, a))
    y = prune(mix(div(x, 32), x))
    prune(mix(y * 2048, y))
  end

  defp twoThounsadthSecret(a) do
    1..2000 |> Enum.reduce(a, fn _, acc -> nextSecret(acc) end)
  end

  defp read() do
    path = Application.app_dir(:aoc, "priv/static/input/22.txt")

    case File.read(path) do
      {:ok, content} ->
        Util.lines(content)
        |> Enum.filter(&(String.length(&1) > 0))
        |> Enum.map(&String.to_integer/1)
    end
  end
end
