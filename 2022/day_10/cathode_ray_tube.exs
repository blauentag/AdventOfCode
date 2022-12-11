defmodule CathodeRayTube do
  def instructions do
    File.read!("input.txt")
    |> String.split("\n", trim: true)
  end

  def addx_strength(instruction, cycle, strength, strengths) do
    instruction
    |> Enum.reduce({cycle, strength, strengths}, fn step, signal ->
      {cycle, strength, strengths} = signal
      steps(step, cycle, strength, strengths)
    end)
  end

  def bucket?(cycle) do
    Enum.member?([20, 60, 100, 140, 180, 220], cycle)
  end

  def noop_strength(cycle, strength, strengths) do
    cycle = cycle + 1

    cond do
      bucket?(cycle) -> {cycle, strength, List.insert_at(strengths, -1, cycle * strength)}
      true -> {cycle, strength, strengths}
    end
  end

  def op_strength(cycle, strength, strengths, step) do
    cycle = cycle + 1

    cond do
      bucket?(cycle) -> {cycle, strength + step, List.insert_at(strengths, -1, cycle * strength)}
      true -> {cycle, strength + step, strengths}
    end
  end

  def parse(instruction, cycle, strength, strengths) do
    instruction
    |> String.split(" ", trim: true)
    |> then(&case &1 do
        [addx, int] -> addx_strength([addx, int], cycle, strength, strengths)
        [_] -> noop_strength(cycle, strength, strengths)
      end)
  end

  def steps(step, cycle, strength, strengths) do
    cond do
      Regex.match?(~r{\A(\d+|-\d+)\z}, step) ->
        op_strength(cycle, strength, strengths, String.to_integer(step))

      true ->
        noop_strength(cycle, strength, strengths)
    end
  end

  def sum_signal_strengths() do
    instructions()
    |> Enum.reduce({0, 1, []}, fn instruction, signal ->
      {cycle, strength, strengths} = signal
      parse(instruction, cycle, strength, strengths)
    end)
    |> then(&elem(&1, 2))
    |> Enum.sum()
  end

  def update(viewport, cycle) do
    viewport
    |> Enum.with_index()
    |> Enum.map(fn row_ind ->
      {row, index} = row_ind

      if index ==
           (cond do
              Enum.member?(1..40, cycle + 1) -> 0
              Enum.member?(41..80, cycle + 1) -> 1
              Enum.member?(81..120, cycle + 1) -> 2
              Enum.member?(121..160, cycle + 1) -> 3
              Enum.member?(161..200, cycle + 1) -> 4
              Enum.member?(201..240, cycle + 1) -> 5
              true -> nil
            end) do
        List.replace_at(row, cycle - 40 * index, "#")
      else
        row
      end
    end)
  end

  def addx(instruction, cycle, sprite, viewport, x) do
    instruction
    |> Enum.reduce({cycle, x, viewport}, fn step, screen ->
      {cycle, x, viewport} = screen
      stepped_instructions(step, cycle, sprite, viewport, x)
    end)
  end

  def instruct(instruction, cycle, sprite, viewport, x) do
    instruction
    |> String.split(" ", trim: true)
    |> then(
      &case &1 do
        [addx, int] -> addx([addx, int], cycle, sprite, viewport, x)
        [_] -> noop(cycle, sprite, viewport, x)
      end
    )
  end

  def noop(cycle, sprite, viewport, x) do
    next_cycle = cycle + 1

    if Enum.member?(sprite, rem(cycle, 40)) do
      {next_cycle, x, update(viewport, cycle)}
    else
      {next_cycle, x, viewport}
    end
  end

  def print do
    instructions()
    |> Enum.reduce({0, 1, screen()}, fn instruction, screen ->
      {cycle, x, viewport} = screen
      sprite = (x - 1)..(x + 1)
      instruct(instruction, cycle, sprite, viewport, x)
    end)
    |> then(&elem(&1, 2))
    |> Enum.each(fn row -> IO.puts(row) end)
  end

  def screen do
    for _x <- 0..5, do: for(_x <- 0..39, do: ".")
  end

  def stepped_instructions(instruction, cycle, sprite, viewport, x) do
    cond do
      Regex.match?(~r{\A(\d+|-\d+)\z}, instruction) ->
        noop(cycle, sprite, viewport, x + String.to_integer(instruction))

      true ->
        noop(cycle, sprite, viewport, x)
    end
  end
end

CathodeRayTube.sum_signal_strengths() |> IO.inspect(label: "Step 1")
CathodeRayTube.print() |> IO.inspect(label: "Step 2")
