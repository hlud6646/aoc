from pathlib import Path

def scaffold(i):
    return  f"""
defmodule Solution{i} do
    # import Enum

     @moduledoc \"\"\"
     Solution for Day {i} of Advent of Code.

     What are we learning?
     \"\"\"

    # def solve do
    # end

    # def solve2 do
    # end

    # defp read do
    # end

end
"""
for i in range(1, 26):
    i = f"{i:02d}"
    p = Path() / f"Solution{i}.ex"
    if not p.exists():
        p.write_text(scaffold(i))
