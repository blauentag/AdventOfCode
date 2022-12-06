defmodule SupplyStacks do
  def stacks_and_procedure do
    File.read!("input.txt")
    |> String.split("\n\n", trim: true)
  end

  def stacks do
    String.split(Enum.at(stacks_and_procedure(), 0), "\n")
    |> Enum.map(&String.split(&1, ""))
    |> Enum.map(&Enum.slice(&1, 2..-3))
    |> Enum.map(&Enum.take_every(&1, 4))
    |> Enum.reverse()
    |> numbered_stacks()
  end

  def procedure do
    Enum.at(stacks_and_procedure(), 1)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1))
    |> Enum.map(&Enum.slice(&1, 1..-1))
    |> Enum.map(&Enum.take_every(&1, 2))
    |> Enum.map(&List.replace_at(&1, 0, String.to_integer(List.first(&1))))
  end

  def numbered_stacks(stacks) do
    Enum.map(stacks, &Enum.reject(&1, fn crate -> crate == " " end))
    [numbers | crates] = stacks

    Map.new(
      Enum.zip(
        numbers,
        Enum.zip(crates)
        |> Enum.map(&Tuple.to_list/1)
        |> Enum.map(&Enum.reject(&1, fn crate -> crate == " " end))
      )
    )
  end

  def move_crate(from, to, stacks) do
    popped = List.pop_at(stacks[from], -1)

    stacks
    |> Map.update!(to, &List.insert_at(&1, -1, elem(popped, 0)))
    |> Map.replace!(from, elem(popped, 1))
  end

  def moves_one_at_a_time(step, stacks) do
    Enum.reduce(0..(Enum.at(step, 0) - 1), stacks, fn _move, stacks ->
      move_crate(Enum.at(step, 1), Enum.at(step, 2), stacks)
    end)
  end

  def rearrange_one_crate_at_a_time do
    Enum.reduce(procedure(), stacks(), fn step, stacks -> moves_one_at_a_time(step, stacks) end)
    |> Enum.map_join(fn {_number, crates} -> List.last(crates) end)
  end

  def moves_block(step, stacks) do
    split_stack = Enum.split(stacks[Enum.at(step, 1)], 0 - Enum.at(step, 0))

    stacks
    |> Map.update!(Enum.at(step, 2), fn crate -> crate ++ elem(split_stack, 1) end)
    |> Map.replace!(Enum.at(step, 1), elem(split_stack, 0))
  end

  def rearrange_block_at_a_time do
    Enum.reduce(procedure(), stacks(), fn step, stacks -> moves_block(step, stacks) end)
    |> Enum.map_join(fn {_number, crates} -> List.last(crates) end)
  end
end

SupplyStacks.rearrange_one_crate_at_a_time() |> IO.inspect(label: "Part 1")
SupplyStacks.rearrange_block_at_a_time() |> IO.inspect(label: "Part 2")
