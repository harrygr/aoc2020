defmodule Day7 do
  def parse_rules(input) do
    input
    |> String.split("\n", trim: true)
    |> Stream.map(&String.split(&1, " contain "))
    |> Stream.map(fn [bag | rules] ->
      outer = String.replace(bag, " bags", "")

      inner =
        rules
        |> Stream.filter(&(!String.contains?(&1, "no other bags")))
        |> Enum.flat_map(fn rs ->
          rs
          |> String.split(", ")
          |> Stream.map(&String.split(&1, " ", trim: true))
          |> Enum.map(fn parts ->
            bag_count = parts |> List.first() |> String.to_integer()
            bag_color = parts |> Enum.slice(1, 2) |> Enum.join(" ")

            {bag_count, bag_color}
          end)
        end)

      {outer, inner}
    end)
    |> Enum.into(%{})
  end

  def can_hold_bag?(ruleset, inner_bags) do
    inner_bags
    |> Enum.any?(fn {_, rule} ->
      case rule do
        "shiny gold" -> true
        c -> can_hold_bag?(ruleset, Map.get(ruleset, c))
      end
    end)
  end

  def count_valid_outer_bags(ruleset) do
    ruleset
    |> Stream.filter(fn {_outer, inner_bags} ->
      can_hold_bag?(ruleset, inner_bags)
    end)
    |> Enum.count()
  end

  def count_nested_bags(ruleset, color) do
    ruleset
    |> Map.get(color, [])
    |> Enum.reduce(0, fn {count, rule}, acc ->
      acc + count + count * count_nested_bags(ruleset, rule)
    end)
  end
end

# input = """
# light red bags contain 1 bright white bag, 2 muted yellow bags.
# dark orange bags contain 3 bright white bags, 4 muted yellow bags.
# bright white bags contain 1 shiny gold bag.
# muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
# shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
# dark olive bags contain 3 faded blue bags, 4 dotted black bags.
# vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
# faded blue bags contain no other bags.
# dotted black bags contain no other bags.
# """

input = File.read!("./lib/day_7/input.txt")

Day7.parse_rules(input)
|> Day7.count_nested_bags("shiny gold")
|> IO.inspect()
