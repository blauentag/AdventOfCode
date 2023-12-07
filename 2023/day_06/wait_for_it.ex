defmodule WaitForIt do
  def ways_to_win(file_name, part) do
    setup(file_name)
    |> parse(part)
    |> Enum.map(fn {time, distance} ->
      calculate_win_count(time, distance)
    end)
    |> Enum.product
  end

  def calculate_win_count(time, distance) do
    1..time - 1
    |> Enum.reduce(0, fn step, acc ->
      if step * (time - step) > distance, do: acc + 1, else: acc
    end)
  end

  def parse(lines, part) do
    Enum.map(lines, fn line ->
      String.split(line, ":", trim: true)
      |> List.last
      |> split_into_races(part)
    end)
    |> Enum.zip
  end

  def split_into_races(line, part) do
    case part do
    1 -> Regex.split(~r/\s+/, line, trim:  true)
         |> Enum.map(fn str -> Integer.parse(str) |> elem(0) end)
    2 -> [Regex.split(~r/\s+/, line, trim:  true) |> Enum.join("")
         |>  Integer.parse |> elem(0)]
    end
  end

  def setup(file_name) do
    File.read!(file_name) |> String.split("\n", trim: true)
  end
end
