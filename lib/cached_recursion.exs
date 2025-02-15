defmodule CachedRecursion do
  # Classicallly bad way to do it.
  def fib(0), do: 1
  def fib(1), do: 1
  def fib(n), do: fib(n - 1) + fib(n - 2)

  def fib_cached(0), do: {1, %{0 => 1}}
  def fib_cached(1), do: {1, %{0 => 1, 1 => 1}}

  def fib_cached(n) do
    {y, cache} = fib_cached(n - 1)
    x = Map.fetch!(cache, n - 2)
    {x + y, Map.put(cache, n, x + y)}
  end

  def fib2(n) do
    {res, _cache} = fib_cached(n)
    res
  end
end
