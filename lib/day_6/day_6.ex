defmodule Day6 do
  def count_answers(input) do
    input
    |> parse_input()
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Stream.map(&String.split(&1, "", trim: true))
    |> Stream.map(&Enum.uniq/1)
    |> Enum.reduce(0, fn el, acc -> acc + Enum.count(el) end)
  end

  def count_all_yesses(input) do
    input
    |> parse_input()
    |> Stream.map(&String.split(&1, "\n", trim: true))
    |> Stream.map(fn answers ->
      answers
      |> Enum.join("")
      |> String.split("", trim: true)
      |> Stream.uniq()
      |> Enum.reduce(0, fn letter, acc ->
        case Enum.all?(answers, &String.contains?(&1, letter)) do
          true -> acc + 1
          false -> acc
        end
      end)
    end)
    |> Enum.sum()
  end

  def parse_input(input) do
    input
    |> String.split("\n\n")
  end
end

_input = """
abc

a
b
c

ab
ac

a
a
a
a

b
"""

input = File.read!("./lib/day_6/input.txt")

Day6.count_all_yesses(input) |> IO.inspect()
