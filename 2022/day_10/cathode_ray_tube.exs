defmodule CathodeRayTube do
  def instructions do
    File.read!("input.txt")
    |> String.split("\n", trim: true)
  end

  def sum_signal_strengths() do
    instructions()
    |> Enum.reduce({0, 1, []}, fn instruction, signal ->
      {cycle, strength, strengths} = signal

      if instruction == "noop" do
        cycle = cycle + 1

        if Enum.member?([20, 60, 100, 140, 180, 220], cycle) do
          {cycle, strength, List.insert_at(strengths, -1, cycle * strength)}
        else
          {cycle, strength, strengths}
        end
      else
        String.split(instruction, " ", trim: true)
        |> Enum.reduce(signal, fn add_x, value ->
          {cycle, strength, strengths} = value

          if Regex.match?(~r{\A(\d+|-\d+)\z}, add_x) do
            cycle = cycle + 1
            cycled_strength = strength + String.to_integer(add_x)

            if Enum.member?([20, 60, 100, 140, 180, 220], cycle) do
              {cycle, cycled_strength, List.insert_at(strengths, -1, cycle * strength)}
            else
              {cycle, cycled_strength, strengths}
            end
          else
            cycle = cycle + 1

            if Enum.member?([20, 60, 100, 140, 180, 220], cycle) do
              {cycle, strength, List.insert_at(strengths, -1, cycle * strength)}
            else
              {cycle, strength, strengths}
            end
          end
        end)
      end
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

  def screen do
    for _x <- 0..5, do: for(_x <- 0..39, do: ".")
  end

  def print do
    instructions()
    |> Enum.reduce({0, 1, screen()}, fn instruction, screen ->
      {cycle, x, viewport} = screen
      sprite = (x - 1)..(x + 1)

      if instruction == "noop" do
        next_cycle = cycle + 1

        if Enum.member?(sprite, rem(cycle, 40)) do
          {next_cycle, x, update(viewport, cycle)}
        else
          {next_cycle, x, viewport}
        end
      else
        String.split(instruction, " ", trim: true)
        |> Enum.reduce(screen, fn step, value ->
          {cycle, x, viewport} = value
          next_cycle = cycle + 1

          if Regex.match?(~r{\A(\d+|-\d+)\z}, step) do
            if Enum.member?(sprite, rem(cycle, 40)) do
              {next_cycle, x + String.to_integer(step), update(viewport, cycle)}
            else
              {next_cycle, x + String.to_integer(step), viewport}
            end
          else
            if Enum.member?(sprite, rem(cycle, 40)) do
              {next_cycle, x, update(viewport, cycle)}
            else
              {next_cycle, x, viewport}
            end
          end
        end)
      end
    end)
    |> then(&elem(&1, 2))
    |> Enum.each(fn row -> IO.puts(row) end)
  end
end

CathodeRayTube.sum_signal_strengths() |> IO.inspect(label: "Step 1")
CathodeRayTube.print() |> IO.inspect(label: "Step 2")
