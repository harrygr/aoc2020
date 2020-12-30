defmodule Day10 do
  def format_input(input),
    do: input |> String.split("\n", trim: true) |> Stream.map(&String.to_integer/1) |> Enum.sort()

  def part_1(adapters, input, diffs) do
    # IO.inspect(input)

    counts =
      case Enum.find(adapters, &(&1 > input && &1 <= input + 3)) do
        nil ->
          diffs

        adapter_to_use ->
          diff = adapter_to_use - input
          IO.inspect(adapter_to_use)

          part_1(
            adapters,
            adapter_to_use,
            Map.update(diffs, diff, 1, &(&1 + 1))
          )
      end

    counts
  end
end

input = """
28
33
18
42
31
14
46
20
48
47
24
23
49
45
19
38
39
11
1
32
25
35
8
17
7
9
4
2
34
10
3
"""

input = File.read!("./lib/day_10/input.txt")
Day10.format_input(input) |> Day10.part_1(0, %{3 => 1}) |> IO.inspect()
