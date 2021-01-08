defmodule Day11 do
  @slopes [{0, -1}, {-1, 1}, {-1, 0}, {-1, -1}, {1, 1}, {1, 0}, {1, -1}, {0, 1}]

  def build_grid(input) do
    input
    |> String.split("\n", trim: true)
    |> Stream.with_index()
    |> Enum.reduce(%{}, fn {row, y}, grid ->
      next_row =
        row
        |> String.split("", trim: true)
        |> Stream.with_index()
        |> Enum.reduce(%{}, fn {seat, x}, acc ->
          Map.put(acc, {x, y}, seat)
        end)

      Map.merge(grid, next_row)
    end)
    |> Enum.into(%{})
  end

  def part_1(grid) do
    grid
    |> get_steady_state(:adjacent)
    |> count_occupied()
  end

  def part_2(grid) do
    grid
    |> get_steady_state(:visible)
    |> count_occupied()
  end

  defp count_occupied(grid) do
    grid
    |> Stream.filter(fn {_, seat} -> seat === "#" end)
    |> Enum.count()
  end

  defp get_steady_state(grid, type) do
    case next_state(grid, type) do
      ^grid -> grid
      new_state -> get_steady_state(new_state, type)
    end
  end

  defp next_state(grid, type) do
    grid
    |> Stream.map(&next_seat_state(grid, &1, type))
    |> Enum.into(%{})
  end

  defp next_seat_state(_grid, {{x, y}, "."}, _type), do: {{x, y}, "."}

  defp next_seat_state(grid, {{x, y}, seat}, :adjacent) do
    case {seat, count_adjacent_occupied(grid, {x, y})} do
      {"L", 0} -> {{x, y}, "#"}
      {"#", adjacent_occupied} when adjacent_occupied > 3 -> {{x, y}, "L"}
      _ -> {{x, y}, seat}
    end
  end

  defp next_seat_state(grid, {coords, seat}, :visible) do
    case {seat, count_visible_occupied(grid, coords)} do
      {"L", 0} -> {coords, "#"}
      {"#", visible_occupied} when visible_occupied > 4 -> {coords, "L"}
      _ -> {coords, seat}
    end
  end

  defp count_adjacent_occupied(grid, {x, y}) do
    @slopes
    |> Enum.reduce(0, fn {dx, dy}, acc ->
      neighbor = Map.get(grid, {x - dx, y - dy}, "")

      case neighbor do
        "#" -> acc + 1
        _ -> acc
      end
    end)
  end

  defp count_visible_occupied(grid, {x, y}) do
    @slopes
    |> Enum.reduce(0, fn slope, acc ->
      acc + line_of_sight(grid, {x, y}, slope)
    end)
  end

  defp line_of_sight(grid, {x, y}, {dx, dy}) do
    next_visible_seat = {x - dx, y - dy}

    case Map.get(grid, next_visible_seat) do
      nil -> 0
      "L" -> 0
      "#" -> 1
      "." -> line_of_sight(grid, next_visible_seat, {dx, dy})
    end
  end

  defp get_neighbors({x, y}) do
    for ox <- (x - 1)..(x + 1), oy <- (y - 1)..(y + 1) do
      {ox, oy}
    end
  end
end

ex1 = """
L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL
"""

input = File.read!("./lib/day_11/input.txt")
# Day11.build_grid(ex1) |> Day11.part_1() |> IO.inspect()
Day11.build_grid(input) |> Day11.part_2() |> IO.inspect()
