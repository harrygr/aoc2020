defmodule Day9 do
  @preamble 25
  def format_input(input),
    do: input |> String.split("\n", trim: true) |> Enum.map(&String.to_integer/1)

  def part_1(numbers, from) do
    prev = Enum.slice(numbers, from..(from + @preamble - 1))
    target = Enum.at(numbers, from + @preamble)

    results =
      for a <- prev, b <- prev, a + b === target do
        {a, b}
      end

    case results do
      [] -> target
      _ -> part_1(numbers, from + 1)
    end
  end

  def part_2(numbers) do
    target = part_1(numbers, 0)

    len = Enum.count(numbers)
    IO.inspect(numbers)

    [range | _] =
      for l <- 0..(len - 1), r <- l..(len - 1), Enum.sum(Enum.slice(numbers, l..r)) === target do
        Enum.slice(numbers, l..r)
      end

    Enum.min(range) + Enum.max(range)
  end
end

input = """
35
20
15
25
47
40
62
55
65
95
102
117
150
182
127
219
299
277
309
576
"""

input = File.read!("./lib/day_9/input.txt")
Day9.format_input(input) |> Day9.part_2() |> IO.inspect()
