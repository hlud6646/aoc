defmodule Solution1 do
  import Enum
  import Util

  def solve do
    {list1, list2} = read()
    zip_with(list1, list2, fn x, y -> abs(x - y) end) |> sum
  end

  def solve2 do
    {list1, list2} = read()
    list1 |> map(fn n -> n * Map.get(frequencies(list2), n, 0) end) |> sum()
  end

  defp read do
    path = Application.app_dir(:aoc, "priv/static/input/1.txt")

    case File.read(path) do
      {:ok, content} ->
        lines(content)
        |> map(&String.split/1)
        |> map(&List.to_tuple/1)
        |> filter(fn t -> tuple_size(t) == 2 end)
        |> unzip()
        |> then(fn {list1, list2} ->
          {sort(map(list1, &String.to_integer/1)), sort(map(list2, &String.to_integer/1))}
        end)
    end
  end
end
