defmodule Day8 do
  def part_1(instructions) do
    run(instructions, 0, MapSet.new(), 0)
  end

  def part_2(instructions, idx) do
    new_instructions =
      case Enum.at(instructions, idx) do
        {"nop", op, inc} -> List.replace_at(instructions, idx, {"jmp", op, inc})
        {"jmp", op, inc} -> List.replace_at(instructions, idx, {"nop", op, inc})
        _ -> instructions
      end

    case run(new_instructions, 0, MapSet.new(), 0) do
      {:ok, n} -> n
      {:error, _} -> part_2(instructions, idx + 1)
    end
  end

  defp run(instructions, idx, seen_idx, acc) do
    cond do
      MapSet.member?(seen_idx, idx) ->
        {:error, acc}

      idx >= Enum.count(instructions) ->
        {:ok, acc}

      true ->
        with new_seen_idx <- MapSet.put(seen_idx, idx) do
          case Enum.at(instructions, idx) do
            {"nop", _, _} -> run(instructions, idx + 1, new_seen_idx, acc)
            {"acc", "+", n} -> run(instructions, idx + 1, new_seen_idx, acc + n)
            {"acc", "-", n} -> run(instructions, idx + 1, new_seen_idx, acc - n)
            {"jmp", "+", n} -> run(instructions, idx + n, new_seen_idx, acc)
            {"jmp", "-", n} -> run(instructions, idx - n, new_seen_idx, acc)
          end
        end
    end
  end

  def parse_instructions(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn ins ->
      {op, inc} = String.split_at(ins, 3)

      {dir, acc} =
        inc
        |> String.slice(1..-1)
        |> String.split_at(1)

      {op, dir, String.to_integer(acc)}
    end)
  end
end

input = """
nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6
"""

# input = File.read!("./lib/day_8/input.txt")
Day8.parse_instructions(input) |> Day8.part_2(0) |> IO.inspect()
