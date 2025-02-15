defmodule AocTest do
  use ExUnit.Case

  doctest Aoc

  test "Can read input file" do
    path =
      Path.join([
        :code.priv_dir(:aoc),
        "static",
        "input",
        "16.txt"
      ])

    assert File.exists?(path)
  end

  test "Can read file using app_dir" do
    path = Application.app_dir(:aoc, "priv/static/input/1.txt")
    assert File.exists?(path)
  end

  test "Day 1" do
    assert Solution1.solve() == 1_882_714
    assert Solution1.solve2() == 19_437_052
  end

  test "Day 2" do
    assert Solution2.solve() == 524
    assert Solution2.solve2() == 569
  end

  test "Day 3" do
    assert Solution3.solve() == 161_085_926
    assert Solution3.solve2() == 82_045_421
  end

  test "Day 4" do
    assert Solution4.solve() == 2554
    assert Solution4.solve2() == 1916
  end

  test "Day 5" do
    assert Solution5.solve() == 4774
    assert Solution5.solve2() == 6004
  end

  # test "Day 6" do
  #   assert Solution6.solve == 42
  #   assert Solution6.solve2 == 42
  # end

  @tag :skip
  test "Day 7" do
    assert Solution7.solve() == 5_702_958_180_383
    assert Solution7.solve2() == 92_612_386_119_138
  end

  test "Day 8" do
    assert Solution8.solve() == 220
    assert Solution8.solve2() == 813
  end

  @tag :skip
  test "Day 9" do
    assert Solution9.solve() == 6_288_707_484_810
    assert Solution9.solve2() == 6_311_837_662_089
  end

  test "Day 10" do
    assert Solution10.solve() == 789
    assert Solution10.solve2() == 1735
  end

  test "Day 11" do
    assert Solution11.solve() == 224_529
    assert Solution11.solve2() == 266_820_198_587_914
  end

  test "Day 12" do
    assert Solution12.solve() == 1_461_752
    assert Solution12.solve2() == 904_114
  end

  # test "Day 13" do
  #   assert Solution13.solve == 42
  #   assert Solution13.solve2 == 42
  # end

  # test "Day 14" do
  #   assert Solution14.solve == 42
  #   assert Solution14.solve2 == 42
  # end

  # test "Day 15" do
  #   assert Solution15.solve == 42
  #   assert Solution15.solve2 == 42
  # end

  # test "Day 16" do
  #   assert Solution16.solve == 42
  #   assert Solution16.solve2 == 42
  # end

  # test "Day 17" do
  #   assert Solution17.solve == 42
  #   assert Solution17.solve2 == 42
  # end

  # test "Day 18" do
  #   assert Solution18.solve == 42
  #   assert Solution18.solve2 == 42
  # end

  # test "Day 19" do
  #   assert Solution19.solve == 42
  #   assert Solution19.solve2 == 42
  # end

  # test "Day 20" do
  #   assert Solution20.solve == 42
  #   assert Solution20.solve2 == 42
  # end

  # test "Day 21" do
  #   assert Solution21.solve == 42
  #   assert Solution21.solve2 == 42
  # end

  # test "Day 22" do
  #   assert Solution22.solve == 42
  #   assert Solution22.solve2 == 42
  # end

  # test "Day 23" do
  #   assert Solution23.solve == 42
  #   assert Solution23.solve2 == 42
  # end

  # test "Day 24" do
  #   assert Solution24.solve == 42
  #   assert Solution24.solve2 == 42
  # end

  # test "Day 25" do
  #   assert Solution25.solve == 42
  #   assert Solution25.solve2 == 42
  # end
end
