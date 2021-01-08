defmodule PointPlotter do
  def plot(points) do
    {mx, my, w, h} = viewbox(points)

    path = polyline_path(points)

    stroke_width = (w + h) / 2 / 1000

    svg = """
    <svg viewBox="#{mx} #{my} #{w} #{h}" xmlns="http://www.w3.org/2000/svg">
    <style>polyline{fill:none; stroke-width: #{stroke_width}px;} .l1{stroke: salmon;} .l2{stroke: teal;}</style>
    <circle cx="0" cy="0" r="#{stroke_width * 3}" fill="orange"/>
    <polyline points="#{path}" class="l1" />
    </svg>
    """

    File.write!("./journey.svg", svg)
  end

  defp polyline_path(points) do
    points
    |> Stream.map(fn {x, y} -> "#{x},#{y}" end)
    |> Enum.join(" ")
  end

  defp viewbox_size({min_x, min_y}, points) do
    Enum.reduce(points, {0, 0}, fn {x, y}, {w, h} -> {max(x - min_x, w), max(y - min_y, h)} end)
  end

  defp viewbox_origin(points) do
    Enum.reduce(points, {0, 0}, fn {x, y}, {m_x, m_y} -> {min(x, m_x), min(y, m_y)} end)
  end

  defp viewbox(points) do
    {mx, my} = viewbox_origin(points)
    {w, h} = viewbox_size({mx, my}, points)

    {mx - 3, my - 3, w + 4, h + 4}
  end
end

defmodule Day12 do
  def part_1(input) do
    final_pos =
      input
      |> prepare_input()
      |> travel({{0, 0}, 90})

    manhattan_dist(final_pos)
  end

  def part_2(input) do
    instructions = prepare_input(input)
    wp = {10, 1}
    ship = {0, 0}

    follow_wp(instructions, {ship, wp})
    |> manhattan_dist()
  end

  def follow_wp([], {ship, _wp}), do: ship
  def follow_wp([ins | rest], x), do: follow_wp(rest, move_wp(ins, x))

  defp move_wp({"N", v}, {ship, {wp_x, wp_y}}), do: {ship, {wp_x, wp_y + v}}
  defp move_wp({"E", v}, {ship, {wp_x, wp_y}}), do: {ship, {wp_x + v, wp_y}}
  defp move_wp({"S", v}, {ship, {wp_x, wp_y}}), do: {ship, {wp_x, wp_y - v}}
  defp move_wp({"W", v}, {ship, {wp_x, wp_y}}), do: {ship, {wp_x - v, wp_y}}

  defp move_wp({"R", v}, {{x, y}, {wp_x, wp_y}}) do
    case v do
      90 -> {{x, y}, {wp_y, -wp_x}}
      180 -> {{x, y}, {-wp_x, -wp_y}}
      270 -> {{x, y}, {-wp_y, wp_x}}
    end
  end

  defp move_wp({"L", 90}, state), do: move_wp({"R", 270}, state)
  defp move_wp({"L", 180}, state), do: move_wp({"R", 180}, state)
  defp move_wp({"L", 270}, state), do: move_wp({"R", 90}, state)

  defp move_wp({"F", v}, {{x, y}, {wp_x, wp_y}}) do
    {{x + wp_x * v, y + wp_y * v}, {wp_x, wp_y}}
  end

  def plot_ship_journey(input) do
    initial = {{0, 0}, 90}

    {_, journey} =
      input
      |> prepare_input()
      |> Enum.reduce({initial, [initial]}, fn ins, {ship, journey} ->
        new_ship = move(ins, ship)
        {new_ship, journey ++ [new_ship]}
      end)

    journey
    |> Stream.map(fn {coords, _} -> coords end)
    |> PointPlotter.plot()
  end

  def prepare_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Stream.map(&String.split_at(&1, 1))
    |> Stream.map(fn {ins, v} -> {ins, String.to_integer(v)} end)
    |> Enum.to_list()
  end

  defp travel([], {ship, _}), do: ship
  defp travel([ins | rest], ship), do: travel(rest, move(ins, ship))

  defp move({"N", v}, {{x, y}, dir}), do: {{x, y + v}, dir}
  defp move({"S", v}, {{x, y}, dir}), do: {{x, y - v}, dir}
  defp move({"E", v}, {{x, y}, dir}), do: {{x + v, y}, dir}
  defp move({"W", v}, {{x, y}, dir}), do: {{x - v, y}, dir}
  defp move({"R", v}, {{x, y}, dir}), do: {{x, y}, rem(dir + v, 360)}
  defp move({"L", v}, {{x, y}, dir}), do: {{x, y}, rem(360 + dir - v, 360)}

  defp move({"F", v}, {{x, y}, dir}) do
    case dir do
      0 -> {{x, y + v}, dir}
      90 -> {{x + v, y}, dir}
      180 -> {{x, y - v}, dir}
      270 -> {{x - v, y}, dir}
    end
  end

  defp manhattan_dist({x, y}) do
    abs(x) + abs(y)
  end
end

ex1 = """
F10
N3
F7
R90
F11
"""

input = File.read!("./lib/day_12/input.txt")
Day12.part_2(input) |> IO.inspect()
