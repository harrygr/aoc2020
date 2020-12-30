defmodule Day1 do
  def part_1(input) do
    Enum.reduce(input, nil, fn x, acc ->
      case acc do
        nil ->
          with y when not is_nil(y) <- Enum.find(input, &(x + &1 === 2020)) do
            x * y
          end

        a ->
          a
      end
    end)
  end

  def part_2(input) do
    [ans | _] =
      for a <- input, b <- input, c <- input, a + b + c === 2020 do
        a * b * c
      end

    ans
  end
end

input = [1721, 979, 366, 299, 675, 1456]

Day1.part_1(input) |> IO.inspect()
Day1.part_2(input) |> IO.inspect()
