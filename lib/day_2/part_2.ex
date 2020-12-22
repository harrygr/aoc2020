defmodule Day2.Part2 do
  def run() do
    File.stream!("./lib/day_2/input.txt")
    |> Stream.map(&parseLine/1)
    |> Enum.reduce(0, fn r, acc -> if isValidPassword(r), do: acc + 1, else: acc end)
    |> IO.inspect()
  end

  defp parseLine(line) do
    # parse a line like "4-11 s: sssszssnqjsbsvs"
    [positions, char, pw] = String.split(line)
    char = String.first(char)

    [p1, p2] = String.split(positions, "-") |> Enum.map(&String.to_integer/1)

    %{p1: p1, p2: p2, pw: pw, char: char}
  end

  defp isValidPassword(%{p1: p1, p2: p2, pw: pw, char: char}) do
    char1 = String.at(pw, p1 - 1)
    char2 = String.at(pw, p2 - 1)

    (char1 === char && char2 !== char) || (char2 === char && char1 !== char)
  end
end

Day2.Part2.run()
