# IEx.configure(inspect: [charlists: :as_lists])
defmodule RuckSackPack do

  def rucksacks() do
    File.read!("input.txt")
    |> String.split("\n", trim: true)
  end

  def adjustment(item) do
    if item < 96 do
      -38
    else
      -96
    end
  end

  def badge(contents) do
    set_of_sack_0 = for item <- String.graphemes(Enum.at(contents, 0)), into: MapSet.new, do: item
    set_of_sack_1 = for item <- String.graphemes(Enum.at(contents, 1)), into: MapSet.new, do: item
    set_of_sack_2 = for item <- String.graphemes(Enum.at(contents, 2)), into: MapSet.new, do: item

    common_in_sacks_0_and_1 = MapSet.intersection(set_of_sack_0,  set_of_sack_1)
    common_in_sacks_0_and_2 = MapSet.intersection(set_of_sack_0,  set_of_sack_2)

    for item <- set_of_sack_0, MapSet.member?(common_in_sacks_0_and_1, item) and MapSet.member?(common_in_sacks_0_and_2, item), do: item
  end

  def compartmentize(contents) do
    find_duplicate(
      String.slice(contents, 0..trunc(String.length(contents) / 2 - 1)),
      String.slice(contents, trunc(String.length(contents) / 2)..-1)
    )
  end

  def find_duplicate(compartment_0, compartment_1) do
    String.to_charlist(
      String.graphemes(compartment_0)
        |> Enum.find(fn (item) -> String.contains?(compartment_1, item) end)
    )
  end

  def map_priority(priority) do
    priority |> Enum.sum
    |> then(fn (priority) -> priority + adjustment(priority) end)
  end

  def priorities do
    rucksacks()
    |> Enum.map(&compartmentize(&1))
    |> Enum.map(&map_priority(&1))
    |> Enum.sum()
  end

  def badges do
    rucksacks()
    |> Enum.chunk_every(3)
    |> Enum.map(fn contents_of_3_sacks -> badge(contents_of_3_sacks) end)
    |> Enum.map(
      fn badge -> Enum.at(badge, 0)
        |> String.to_charlist()
        |> then(&map_priority(&1))
      end
      )
    |> Enum.sum()
  end

end

RuckSackPack.priorities() |> IO.puts
RuckSackPack.badges() |> IO.puts
