defmodule CampCleanup do

  def organize_assignments do
    File.read!("input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(
      fn
        pair -> String.split(pair, ",", trim: true)
        |> Enum.map(fn sections -> String.split(sections, "-", trim: true) end)
        |> Enum.map(fn sections -> List.flatten(sections) end)
        |> Enum.map(fn section -> section |> Enum.map(&String.to_integer/1) end)
      end
    )
  end

  def fully_contains?(pairs) do
    section_0 = Enum.at(pairs, 0)
    section_1 = Enum.at(pairs, 1)
    (
      (Enum.at(section_0, 0) <= Enum.at(section_1, 0) and Enum.at(section_0, 1) >= Enum.at(section_1, 1))
      or (Enum.at(section_0, 0) >= Enum.at(section_1, 0) and Enum.at(section_0, 1) <= Enum.at(section_1, 1))
    )
  end

  def partially_contains?(pairs) do
    section_0 = Enum.at(pairs, 0)
    section_1 = Enum.at(pairs, 1)
    (
      (Enum.at(section_0, 0) >= Enum.at(section_1, 0) and Enum.at(section_0, 0) <= Enum.at(section_1, 1))
      or (Enum.at(section_0, 1) >= Enum.at(section_1, 0) and Enum.at(section_0, 1) <= Enum.at(section_1, 1))
    )
    or
    (
      (Enum.at(section_1, 0) >= Enum.at(section_0, 0) and Enum.at(section_1, 0) <= Enum.at(section_0, 1))
      or (Enum.at(section_1, 1) >= Enum.at(section_0, 0) and Enum.at(section_1, 1) <= Enum.at(section_0, 1))
    )
  end

  def fully_contained_assignments do
    organize_assignments()
    |> Enum.filter(fn pairs -> fully_contains?(pairs) end)
    |> Enum.count
  end

  def partially_contained_assignments do
    organize_assignments()
    |> Enum.filter(fn pairs -> partially_contains?(pairs) end)
    |> Enum.count
  end

end

CampCleanup.fully_contained_assignments() |> IO.inspect
CampCleanup.partially_contained_assignments() |> IO.inspect
