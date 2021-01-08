defmodule Day14 do
  def prepare_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Stream.map(&parse_instruction/1)
    |> Enum.to_list()
  end

  defp parse_instruction("mask = " <> mask), do: {:mask, mask}

  defp parse_instruction("mem[" <> m) do
    [_, address, val] = Regex.run(~r/(\d+)\] = (\d+)/, m)
    {:mem, {String.to_integer(address), String.to_integer(val)}}
  end

  def to_36_bit_int(n) do
    n
    |> Integer.to_string(2)
    |> String.pad_leading(36, "0")
  end
end

defmodule Day14.Part1 do
  def run(input) do
    input
    |> Day14.prepare_input()
    |> run_init_program(%{}, String.duplicate("X", 36))
  end

  defp run_init_program([], mem, _mask), do: mem |> Enum.reduce(0, fn {_, v}, sum -> v + sum end)

  defp run_init_program([{:mask, mask} | rest], mem, _mask),
    do: run_init_program(rest, mem, mask)

  defp run_init_program([{:mem, {key, val}} | rest], mem, mask) do
    masked_val =
      val
      |> Day14.to_36_bit_int()
      |> apply_mask(mask)
      |> String.to_integer(2)

    run_init_program(rest, Map.put(mem, key, masked_val), mask)
  end

  defp apply_mask(bin, mask) do
    mask_arr = String.graphemes(mask)
    bin_arr = String.graphemes(bin)

    Enum.zip(bin_arr, mask_arr)
    |> Stream.map(fn
      {v, "X"} -> v
      {_, m} -> m
    end)
    |> Enum.join()
  end
end

defmodule Day14.Part2 do
  def run(input) do
    input
    |> Day14.prepare_input()
    |> run_init_program_v2(%{}, String.duplicate("0", 36))
  end

  defp run_init_program_v2([], mem, _mask),
    do: mem |> Enum.reduce(0, fn {_, v}, sum -> v + sum end)

  defp run_init_program_v2([{:mask, mask} | rest], mem, _mask),
    do: run_init_program_v2(rest, mem, mask)

  defp run_init_program_v2([{:mem, {address, val}} | rest], mem, mask) do
    new_mem =
      address
      |> Day14.to_36_bit_int()
      |> apply_address_mask(mask)
      |> Enum.reduce(mem, fn a, acc -> Map.put(acc, a, val) end)

    run_init_program_v2(rest, new_mem, mask)
  end

  defp apply_address_mask(bin, mask) do
    mask_arr = String.graphemes(mask)
    bin_arr = String.graphemes(bin)

    Enum.zip(bin_arr, mask_arr)
    |> Enum.reduce([[]], fn
      {v, "0"}, acc -> Enum.map(acc, &[v | &1])
      {_, "1"}, acc -> Enum.map(acc, &["1" | &1])
      {_, "X"}, acc -> Enum.map(acc, &["1" | &1]) ++ Enum.map(acc, &["0" | &1])
    end)
    |> Stream.map(&Enum.reverse/1)
    |> Stream.map(&Enum.join/1)
    |> Stream.map(&String.to_integer(&1, 2))
    |> Enum.to_list()
  end
end

ex1 = """
mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
mem[8] = 11
mem[7] = 101
mem[8] = 0
"""

ex2 = """
mask = 000000000000000000000000000000X1001X
mem[42] = 100
mask = 00000000000000000000000000000000X0XX
mem[26] = 1
"""

input = File.read!("./lib/day_14/input.txt")

Day14.Part1.run(ex1) |> IO.inspect()
Day14.Part2.run(ex2) |> IO.inspect()
