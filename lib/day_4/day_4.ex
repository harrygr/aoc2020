defmodule Day4 do
  @required_fields [
    "byr",
    "iyr",
    "eyr",
    "hgt",
    "hcl",
    "ecl",
    "pid"
    # "cid"
  ]

  def count_valid(batch) do
    passports =
      batch
      |> String.split("\n\n")
      |> Stream.map(&String.split(&1))
      |> Stream.map(&parse_passport/1)
      |> Stream.filter(&has_required_keys?/1)
      |> Stream.filter(&birth_year_valid?/1)
      |> Stream.filter(&issue_year_valid?/1)
      |> Stream.filter(&exp_year_valid?/1)
      |> Stream.filter(&height_valid?/1)
      |> Stream.filter(&hair_color_valid?/1)
      |> Stream.filter(&eye_color_valid?/1)
      |> Stream.filter(&valid_pid?/1)
      |> Enum.count()

    passports
  end

  def parse_passport(passport) do
    passport
    |> Stream.map(&String.split(&1, ":"))
    |> Enum.reduce(%{}, fn [key, val], data -> Map.put(data, key, val) end)
  end

  defp has_required_keys?(passport) do
    fields_in_passport = passport |> Enum.map(fn {key, _} -> key end)

    @required_fields
    |> Enum.reduce(true, fn field, is_valid ->
      is_valid && Enum.member?(fields_in_passport, field)
    end)
  end

  defp birth_year_valid?(%{"byr" => byr}),
    do: is_within_range?(String.to_integer(byr), {1920, 2002})

  defp issue_year_valid?(%{"iyr" => iyr}),
    do: is_within_range?(String.to_integer(iyr), {2010, 2020})

  defp exp_year_valid?(%{"eyr" => eyr}),
    do: is_within_range?(String.to_integer(eyr), {2020, 2030})

  defp is_within_range?(n, {min, max}), do: n >= min && n <= max

  defp height_valid?(%{"hgt" => hgt}) do
    case String.split_at(hgt, -2) do
      {h, "cm"} ->
        hcm = String.to_integer(h)
        hcm >= 150 && hcm <= 193

      {h, "in"} ->
        hin = String.to_integer(h)
        hin >= 59 && hin <= 76

      _ ->
        false
    end
  end

  defp hair_color_valid?(%{"hcl" => hcl}) do
    String.match?(hcl, ~r/^\#[0-9a-f]{6}\Z/)
  end

  defp eye_color_valid?(%{"ecl" => ecl}) do
    valid_colors = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
    Enum.member?(valid_colors, ecl)
  end

  defp valid_pid?(%{"pid" => pid}) do
    String.match?(pid, ~r/^[0-9]{9}\Z/)
  end
end

_input = """
ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm

iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
hcl:#cfa07d byr:1929

hcl:#ae17e1 iyr:2013
eyr:2024
ecl:brn pid:760753108 byr:1931
hgt:179cm

hcl:#cfa07d eyr:2025 pid:166559648
iyr:2011 ecl:brn hgt:59in
"""

input = File.read!("./lib/day_4/input.txt")

Day4.count_valid(input) |> IO.inspect()
