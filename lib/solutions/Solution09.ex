defmodule Solution9 do
  import Enum
  # TODO: Surely this is way too long...

  def solve do
    path = Application.app_dir(:aoc, "priv/static/input/9.txt")
    {:ok, disk_map} = File.read(path)
    disk_map = String.graphemes(disk_map)
    disk_map = map(disk_map, &String.to_integer/1) |> then(&unpack_disk_map/1)

    free_block? = fn block_id -> block_id == -1 end
    file_block? = fn block_id -> block_id >= 0 end
    free_index? = fn idx -> at(disk_map, idx) == -1 end

    n_free = count(disk_map, free_block?)
    n_file = count(disk_map) - n_free
    blocks_to_move = reverse(drop(disk_map, n_file) |> filter(file_block?))
    disk_map = take(disk_map, n_file)

    free_indices = 0..(count(disk_map) - 1) |> filter(free_index?)

    disk_map =
      reduce(
        zip(free_indices, blocks_to_move),
        disk_map,
        fn {idx, file_id}, disk_map -> List.replace_at(disk_map, idx, file_id) end
      )

    # Checksum
    zip_with(0..count(disk_map), disk_map, fn i, file_id -> i * file_id end) |> sum
  end

  def solve2 do
    path = Application.app_dir(:aoc, "priv/static/input/9.txt")
    {:ok, disk_map} = File.read(path)
    disk_map = String.graphemes(disk_map) |> map(&String.to_integer/1)

    # Algo requires the last block be a free block.
    disk_map =
      case rem(count(disk_map), 2) do
        0 -> disk_map
        _ -> disk_map ++ [0]
      end

    n_blocks = count(disk_map)
    n_files = div(n_blocks - 1, 2)

    blocks =
      0..(n_blocks - 1)
      |> to_list
      |> map(fn i ->
        if rem(i, 2) == 0 do
          {i, div(i, 2), at(disk_map, i)}
          {:file, %{id: div(i, 2), size: at(disk_map, i)}}
        else
          {:free, %{id: -1, size: at(disk_map, i)}}
        end
      end)

    reduce(n_files..1//-1, blocks, &try_move/2) |> then(&checksum/1)
  end

  defp unpack_disk_map(disk_map) do
    zip(0..count(disk_map), disk_map)
    |> map(fn {i, n} ->
      file_id = div(i, 2)

      if rem(i, 2) == 0 do
        List.duplicate(file_id, n)
      else
        List.duplicate(-1, n)
      end
    end)
    |> then(&List.flatten/1)
  end

  defp move(file_id, file_size, file_index, free_index, blocks) do
    {_, %{size: free_size}} = at(blocks, free_index)

    # Put the file block in the free block
    blocks =
      List.replace_at(
        blocks,
        free_index,
        {:file, %{id: file_id, size: file_size}}
      )

    # Insert a free block for whatever space was unused.
    blocks =
      List.insert_at(
        blocks,
        free_index + 1,
        {:free, %{id: -1, size: free_size - file_size}}
      )

    # The original index of the file block is now one larger.
    file_index = file_index + 1

    # Take the blocks on either side
    l_block = {l_type, %{size: l_size}} = at(blocks, file_index - 1)
    r_block = {r_type, %{size: r_size}} = at(blocks, file_index + 1)

    # Construct a new middle
    middle =
      case {l_type, r_type} do
        {:file, :file} ->
          [
            l_block,
            {:free, %{id: -1, size: file_size}},
            r_block
          ]

        {:free, :file} ->
          [
            {:free, %{id: -1, size: l_size + file_size}},
            r_block
          ]

        {:file, :free} ->
          [
            l_block,
            {:free, %{id: -1, size: file_size + r_size}}
          ]

        {:free, :free} ->
          [
            {:free, %{id: -1, size: l_size + file_size + r_size}}
          ]
      end

    blocks_before = take(blocks, file_index - 1)
    blocks_after = drop(blocks, file_index + 2)
    blocks_before ++ middle ++ blocks_after
  end

  defp try_move(file_id, blocks) do
    file_index = find_index(blocks, fn {_, %{id: id}} -> file_id == id end)
    {_, %{size: file_size}} = at(blocks, file_index)
    blocks_before_file = take(blocks, file_index)

    free_index =
      find_index(blocks_before_file, fn {type, %{size: free_size}} ->
        type == :free and free_size >= file_size
      end)

    case free_index do
      nil -> blocks
      _ -> move(file_id, file_size, file_index, free_index, blocks)
    end
  end

  # Debugging function for printing a disk.
  # defp expand(blocks) do
  #   flat_map(blocks, fn {type, %{id: id, size: size}} ->
  #     if type == :file do
  #       List.duplicate(id, size)
  #     else
  #       List.duplicate(0, size)
  #     end
  #   end)
  #   |> map(fn n ->
  #     if n == 0 do
  #       "."
  #     else
  #       to_string(n)
  #     end
  #   end)
  #   |> to_string()
  # end

  defp checksum(blocks) do
    blocks =
      flat_map(blocks, fn {type, %{id: id, size: size}} ->
        if type == :file do
          List.duplicate(id, size)
        else
          List.duplicate(0, size)
        end
      end)

    zip_with(0..count(blocks), blocks, &(&1 * &2)) |> sum
  end
end
