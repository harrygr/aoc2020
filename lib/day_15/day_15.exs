defmodule Day15 do
  def prepare_input(input) do
    input
    |> String.split(",", trim: true)
    |> Stream.map(&String.to_integer/1)
  end
end

defmodule Day15.Part1 do
  def run(input) do
    input
    |> Day15.prepare_input()
    |> Stream.with_index()
    |> Enum.reverse()
    |> iterate(2020)
  end

  def iterate([{candidate, idx} | _numbers], target) when idx === target - 1, do: candidate

  def iterate(numbers, target) do
    [{candidate, idx} | _] = numbers

    new_list =
      case Enum.filter(numbers, fn {c, _} -> c === candidate end) do
        # candidate is new: never spoken before
        [] -> [{0, idx + 1}] ++ numbers
        # candidate has only been spoken once before
        [_ | []] -> [{0, idx + 1}] ++ numbers
        [{_, idx_1} | [{_, idx_2} | _]] -> [{idx_1 - idx_2, idx + 1}] ++ numbers
      end

    iterate(new_list, target)
  end
end

defmodule Day15.Part2 do
  def run(input) do
    nums =
      input
      |> Day15.prepare_input()
      |> Stream.with_index(1)
      |> Enum.into(%{})

    get_nth(nums, 30_000_000, 0, Enum.count(nums) + 1)
  end

  def get_nth(lookup, n, last, turn) when n === turn do
    last
  end

  def get_nth(lookup, n, last, turn) do
    last_spoken = Map.get(lookup, last)

    diff =
      case last_spoken do
        nil -> 0
        i -> turn - i
      end

    get_nth(Map.put(lookup, last, turn), n, diff, turn + 1)
  end
end

ex1 = "0,3,6"

input = "2,0,1,9,5,19"

Day15.Part1.run(ex1) |> IO.inspect()
Day15.Part2.run(input) |> IO.inspect()
