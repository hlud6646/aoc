defmodule GridTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  defp grid_generator do
    gen all(
          height <- integer(1..10),
          width <- integer(1..10),
          contents <-
            list_of(
              list_of(integer(0..9), length: width),
              length: height
            )
        ) do
      contents
    end
  end

  test "dims returns correct dimensions" do
    check all(
            height <- integer(1..10),
            width <- integer(1..10),
            grid <-
              list_of(
                list_of(integer(0..9), length: width),
                length: height
              )
          ) do
      assert Grid.dims(grid) == {height, width}
    end
  end

  test "find returns correct positions" do
    check all(grid <- grid_generator()) do
      # Find all positions of number 5
      positions = Grid.find(grid, &(&1 == 5))

      # Verify each position actually contains 5
      Enum.each(positions, fn {row, col} ->
        assert Enum.at(Enum.at(grid, row), col) == 5
      end)
    end
  end

  test "reflect is reversible" do
    check all(grid <- grid_generator()) do
      result =
        grid
        |> Grid.reflect()
        |> Grid.reflect()

      assert result == grid
    end
  end

  test "flip is reversible" do
    check all(grid <- grid_generator()) do
      result =
        grid
        |> Grid.flip()
        |> Grid.flip()

      assert result == grid
    end
  end

  test "columns and transpose produce same result" do
    check all(grid <- grid_generator()) do
      columns = Grid.columns(grid)
      transposed = Grid.transpose(grid)

      assert columns == transposed
    end
  end

  test "rotate_left and rotate_right are inverses" do
    check all(grid <- grid_generator()) do
      result =
        grid
        |> Grid.rotate_left()
        |> Grid.rotate_right()

      assert result == grid
    end
  end

  test "diagonals returns correct elements" do
    # Test with a simple fixed grid where diagonals are easy to verify
    grid = [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9]
    ]

    diagonals = Grid.diagonals(grid)
    # Top-left diagonal
    assert [3] in diagonals
    # Second diagonal
    assert [2, 6] in diagonals
    # Main diagonal
    assert [1, 5, 9] in diagonals
    # Fourth diagonal
    assert [4, 8] in diagonals
    # Bottom-right diagonal
    assert [7] in diagonals
  end

  test "show returns string representation" do
    grid = [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9]
    ]

    # Capture IO.puts output
    output =
      ExUnit.CaptureIO.capture_io(fn ->
        Grid.show(grid)
      end)

    expected =
      """
      +---+
      |123|
      |456|
      |789|
      +---+
      """
      |> String.trim()

    assert String.trim(output) == expected
  end

  # Original tests
  test "rotate_right four times returns original grid" do
    check all(grid <- grid_generator()) do
      result =
        grid
        |> Grid.rotate_right()
        |> Grid.rotate_right()
        |> Grid.rotate_right()
        |> Grid.rotate_right()

      assert result == grid
    end
  end

  test "transpose twice returns original grid" do
    check all(grid <- grid_generator()) do
      result =
        grid
        |> Grid.transpose()
        |> Grid.transpose()

      assert result == grid
    end
  end
end
