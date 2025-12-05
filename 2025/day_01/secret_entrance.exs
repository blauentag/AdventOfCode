#!/usr/bin/env elixir

defmodule DialProcessor do
  def main(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_instruction/1)
    |> process_dial()
    |> print_results()
  end

  defp parse_instruction(line) do
    case line do
      "R" <> xs -> String.to_integer(xs)
      "L" <> xs -> -String.to_integer(xs)
      _ -> 0
    end
  end

  defp process_dial(instructions) do
    {
      Enum.scan(instructions, 50, fn current, distance -> rem(current + distance, 100) end) |> Enum.count(&(&1 == 0)),
      Enum.reduce(instructions, {50, 0}, fn distance, {dial_position, dial_points_to_zero_count} ->
        count_any_pass_of_zero(distance, dial_position, dial_points_to_zero_count)
      end) |> elem(1)
    }
  end

  defp count_any_pass_of_zero(distance, dial_position, dial_points_to_zero_count) do
    {new_dial_position, dial_rotations} = calculate_dial_position_and_rotations(dial_position, distance)
    {new_dial_position, update_count(dial_points_to_zero_count, dial_rotations, new_dial_position, dial_rotations)}
  end

  defp calculate_dial_position_and_rotations(dial_position, distance) do
    new_dial_position = rem(dial_position + distance, 100) |> normalize_position()
    dial_rotations = quotient(distance, dial_position)
    {new_dial_position, dial_rotations}
  end

  defp update_count(dial_points_to_zero_count, dial_rotations, new_dial_position, dial_rotations) when new_dial_position == 0 and dial_rotations == 0, do: dial_points_to_zero_count + Kernel.abs(dial_rotations) + 1
  defp update_count(dial_points_to_zero_count, dial_rotations, new_dial_position, dial_rotations), do: dial_points_to_zero_count + Kernel.abs(dial_rotations)

  defp normalize_position(position) when position < 0, do: position + 100
  defp normalize_position(position), do: position

  defp quotient(distance, dial_position) when (dial_position > 0 and (dial_position + distance) < 0) or (dial_position < 0 and (dial_position + distance) > 0), do: Kernel.abs(div(dial_position + distance, 100)) + 1
  defp quotient(distance, dial_position), do: Kernel.abs(div(dial_position + distance, 100))

  defp print_results({part1, part2}) do
    IO.puts("Part 1: #{part1}")
    IO.puts("Part 2: #{part2}")
  end
end

case System.argv() do
  [filename] -> DialProcessor.main(filename)
  _ -> IO.puts("Usage: elixir dial_processor.exs <filename>")
end
