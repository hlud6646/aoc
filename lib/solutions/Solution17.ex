defmodule Solutions.SolutionXVII do
  import Enum

  def f(_, _, _, i, program) when i >= length(program) do
    []
  end

  def f(a, b, c, i, program) do
    combo = fn
      n when n <= 3 -> n
      4 -> a
      5 -> b
      6 -> c
    end

    case _opcode = program |> at(i) do
      0 ->
        # adv
        operand = program |> at(i + 1) |> then(combo)
        res = div(a, 2 ** operand)
        f(res, b, c, i + 2, program)

      1 ->
        # bxl
        operand = program |> at(i + 1)
        res = Bitwise.bxor(b, operand)
        f(a, res, c, i + 2, program)

      2 ->
        # bst
        operand = program |> at(i + 1) |> then(combo)
        res = rem(operand, 8)
        f(a, res, c, i + 2, program)

      3 ->
        # jzn
        if a == 0 do
          f(a, b, c, i + 2, program)
        else
          operand = program |> at(i + 1)
          f(a, b, c, operand, program)
        end

      4 ->
        # bxc
        _operand = program |> at(i + 1)
        res = Bitwise.bxor(b, c)
        f(a, res, c, i + 2, program)

      5 ->
        # out
        operand = program |> at(i + 1) |> then(combo)
        res = rem(operand, 8)
        [res | f(a, b, c, i + 2, program)]

      6 ->
        # bdv
        operand = program |> at(i + 1) |> then(combo)
        res = div(a, 2 ** operand)
        f(a, res, c, i + 2, program)

      7 ->
        # cdv
        operand = program |> at(i + 1) |> then(combo)
        res = div(a, 2 ** operand)
        f(a, b, res, i + 2, program)
    end
  end

  def solve do
    # f(729, 0, 0, 0, [0, 1, 5, 4, 3, 0])
    # |> then(&IO.inspect/1)

    f(28_066_687, 0, 0, 0, [2, 4, 1, 1, 7, 5, 4, 6, 0, 3, 1, 4, 5, 5, 3, 0])
    |> map(&to_string/1)
    |> join(",")
    |> then(&IO.puts/1)
  end

  def solve2 do
    # p = [0, 3, 5, 4, 3, 0]
    p = [2, 4, 1, 1, 7, 5, 4, 6, 0, 3, 1, 4, 5, 5, 3, 0]

    1..10000
    |> map(fn a -> {a, f(a, 0, 0, 0, p)} end)
    |> map(&IO.inspect/1)
  end
end
