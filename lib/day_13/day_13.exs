defmodule Day13 do
  def part_1(input) do
    {departure_time, bus_ids} = prepare_input(input)

    {best_bus, wait_time} =
      bus_ids
      |> Stream.filter(&is_integer/1)
      |> Stream.map(fn b ->
        {b, departure_time + b - rem(departure_time, b)}
      end)
      |> Enum.reduce(fn {b, d}, {id, wait_time} ->
        new_wait_time = d - departure_time

        if new_wait_time < wait_time do
          {b, new_wait_time}
        else
          {id, wait_time}
        end
      end)

    best_bus * wait_time
  end

  def part_2(input) do
    {_, bus_ids} = prepare_input(input)

    buses = bus_ids |> Stream.with_index() |> Enum.filter(fn {id, _} -> is_integer(id) end)

    find_earliest_timestamp(buses, 1, 1)
  end

  defp find_earliest_timestamp([], t, _lcm), do: t

  defp find_earliest_timestamp(buses, time, lcm) do
    [{bus, idx} | other_buses] = buses
    # ({7, 1})
    target = bus + idx
    # IO.inspect({time, target, lcm})

    if rem(time, target) === 0 do
      IO.inspect({"found", bus, time, lcm})
      find_earliest_timestamp(other_buses, time, lcm * bus)
    else
      find_earliest_timestamp(buses, time + lcm, lcm)
    end
  end

  def prepare_input(input) do
    [departure_time, bus_ids] = String.split(input, "\n", trim: true)
    bus_ids = bus_ids |> String.split(",", trim: true) |> Enum.map(&parse_bus_id/1)

    {String.to_integer(departure_time), bus_ids}
  end

  defp parse_bus_id("x"), do: "x"
  defp parse_bus_id(id), do: String.to_integer(id)
end

ex1 = """
939
7,13,x,x,59,x,31,19
"""

input = """
1002392
23,x,x,x,x,x,x,x,x,x,x,x,x,41,x,x,x,37,x,x,x,x,x,421,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,17,x,19,x,x,x,x,x,x,x,x,x,29,x,487,x,x,x,x,x,x,x,x,x,x,x,x,13
"""

Day13.part_2(ex1) |> IO.inspect()
