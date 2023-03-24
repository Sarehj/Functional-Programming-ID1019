defmodule Day2 do
  @input_path "input-day2.txt"

  def part1(lines) do
    lines
    |> Enum.map(&String.split/1)
    |> Enum.map(
      &case &1 do
        ["A", "X"] -> 4 #1 + 3
        ["A", "Y"] -> 8 #2 + 6
        ["A", "Z"] -> 3 #3 + 0
        ["B", "X"] -> 1 #1 + 0
        ["B", "Y"] -> 5 #2 + 3
        ["B", "Z"] -> 9 #3 + 6
        ["C", "X"] -> 7 #1 + 6
        ["C", "Y"] -> 2 #2 + 0
        ["C", "Z"] -> 6 #3 + 3
        _ -> 0
      end
    )
    |> Enum.sum()
  end


  def part2(lines) do
    lines
    |> Enum.map(&String.split/1)
    |> Enum.map(
      &case &1 do
        ["A", "X"] -> 3 #3 + 0
        ["A", "Y"] -> 4 #1 + 3
        ["A", "Z"] -> 8 #2 + 6
        ["B", "X"] -> 1 #1 + 0
        ["B", "Y"] -> 5 #2 + 3
        ["B", "Z"] -> 9 #3 + 6
        ["C", "X"] -> 2 #2 + 0
        ["C", "Y"] -> 6 #3 + 3
        ["C", "Z"] -> 7 #1 + 6
        _ -> 0
      end
    )
    |> Enum.sum()
  end

  def get_input do
    @input_path
    |> File.read!()
    |> String.split("\r\n")
  end

  def run() do
    lines = get_input()
    IO.puts("part1: #{part1(lines)}")
    IO.puts("part1: #{part2(lines)}")
  end
end

Day2.run()
