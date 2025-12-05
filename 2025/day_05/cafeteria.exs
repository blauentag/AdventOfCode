#!/usr/bin/env elixir

defmodule IngredientProcessor do
  def main(filename) do
    {:ok, content} = File.read(filename)

    parts = String.split(content, "\n\n", trim: true)

    integers = parts
    |> Enum.at(1)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)

    ranges = parts
    |> Enum.at(0)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [n, m] = String.split(line, "-", trim: true) |> Enum.map(&String.to_integer/1)
      n..(m)
    end)

    Enum.count(integers, fn id ->
      Enum.any?(ranges, fn range -> id in range end)
    end)
    |> IO.inspect(label: "Part 1")

    ranges
    |> merge_overlapping_ranges()
    |> Enum.map(fn range -> range.last - range.first + 1 end)
    |> Enum.sum
    |> IO.inspect(label: "Part 2")
  end

  def merge_overlapping_ranges(ranges) do
    case ranges do
      [] -> []
      _ ->
        sorted_ranges = Enum.sort(ranges, fn r1, r2 -> r1.first < r2.first end)
        reduce_ranges(sorted_ranges, [])
    end
  end

  defp reduce_ranges([], acc), do: Enum.reverse(acc)

  defp reduce_ranges([current | rest], acc) do
    case acc do
      [] -> reduce_ranges(rest, [current])
      [last | _] ->
        if last.last < current.first do
          reduce_ranges(rest, [current | acc])
        else
          new_start = min(last.first, current.first)
          new_stop = max(last.last, current.last)
          reduce_ranges(rest, [new_start..new_stop | tl(acc)])
        end
    end
  end
end

case System.argv() do
  [filename] -> IngredientProcessor.main(filename)
  _ -> IO.puts("Usage: elixir ingredient_processor.exs <filename>")
end
