# It's useful to have a runable module for development.

defmodule Main do
  Solution23.solve() |> then(&IO.inspect(&1, pretty: true, charlists: false, limit: :infinity))
end
