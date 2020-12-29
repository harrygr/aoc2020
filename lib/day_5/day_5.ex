defmodule Day5 do
  def get_position(input) do
    {row_code, col_code} = input |> String.split("", trim: true) |> Enum.split(7)

    {get_row(row_code, {0, 127}), get_col(col_code, {0, 7})}
  end

  def get_seat_id({row, col}), do: row * 8 + col

  defp get_row(["F"], {first, _last}), do: first
  defp get_row(["B"], {_first, last}), do: last

  defp get_row([next | rest], {first, last}) do
    middle = div(last + first, 2)

    case next do
      "F" -> get_row(rest, {first, middle})
      "B" -> get_row(rest, {middle + 1, last})
    end
  end

  defp get_col(["L"], {left, _right}), do: left
  defp get_col(["R"], {_left, right}), do: right

  defp get_col([next | rest], {first, last}) do
    middle = div(last + first, 2)

    case next do
      "L" -> get_col(rest, {first, middle})
      "R" -> get_col(rest, {middle + 1, last})
    end
  end
end

File.read!("./lib/day_5/input.txt")
|> String.split("\n")
|> Stream.filter(&(String.length(&1) > 0))
|> Stream.map(&Day5.get_position/1)
|> Stream.map(&Day5.get_seat_id/1)
|> Enum.sort()
|> Enum.reduce({nil, nil}, fn current, {last, found} ->
  case found do
    nil ->
      if !is_nil(last) && current - last > 1, do: {current, current - 1}, else: {current, nil}

    _ ->
      {current, found}
  end
end)
|> IO.inspect()
