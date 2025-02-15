defmodule Solution2 do
  import Enum
  import Util

  def solve do
    count(read(), &safe?/1)
  end

  def solve2 do
    count(read(), &safe2?/1)
  end

  defp steps(record) do
    zip_with(record, drop(record, 1), fn x, y -> y - x end)
  end

  defp safe_ascending?(record) do
    all?(steps(record), fn d -> 1 <= d and d <= 3 end)
  end

  defp safe_descending?(record) do
    all?(steps(record), fn d -> -3 <= d and d <= -1 end)
  end

  defp safe?(record) do
    safe_ascending?(record) or safe_descending?(record)
  end

  defp safe2?(record) do
    one_removed = 0..(count(record) - 1) |> map(&List.delete_at(record, &1))
    safe?(record) or any?(one_removed, &safe?/1)
  end

  defp read do
    path = Application.app_dir(:aoc, "priv/static/input/2.txt")

    case File.read(path) do
      {:ok, content} ->
        lines(content)
        |> map(fn line -> String.split(line) |> map(&String.to_integer/1) end)
        |> filter(fn record -> count(record) > 0 end)
    end
  end
end
