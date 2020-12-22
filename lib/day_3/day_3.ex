defmodule Day3 do
  def find_trees(grid, move_x, move_y) do
    move(grid, 0, 0, 0, move_x, move_y)
  end

  def get_multiplied_trees_for_slopes(grid, slopes) do
    slopes
    |> Stream.map(fn [move_x, move_y] -> find_trees(grid, move_x, move_y) end)
    |> Enum.reduce(&(&1 * &2))
  end

  def move(grid, x, y, tree_count, move_x, move_y) do
    grid_height = Enum.count(grid) - 1

    grid_width =
      List.first(grid)
      |> String.length()

    point = grid |> Enum.at(y) |> String.at(Integer.mod(x, grid_width))

    new_tree_count = if point === "#", do: tree_count + 1, else: tree_count

    case y do
      ^grid_height ->
        new_tree_count

      _ ->
        move(grid, x + move_x, y + move_y, new_tree_count, move_x, move_y)
    end
  end
end

_input =
  """
  ..##.......
  #...#...#..
  .#....#..#.
  ..#.#...#.#
  .#...##..#.
  ..#.##.....
  .#.#.#....#
  .#........#
  #.##...#...
  #...##....#
  .#..#...#.#
  """
  |> String.split()

input =
  File.read!("./lib/day_3/input.txt")
  |> String.split("\n")
  |> Enum.filter(&(String.length(&1) > 0))

IO.inspect("part 1:")
Day3.find_trees(input, 3, 1) |> IO.inspect()

IO.inspect("part 2:")
slopes = [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]]
Day3.get_multiplied_trees_for_slopes(input, slopes) |> IO.inspect()
