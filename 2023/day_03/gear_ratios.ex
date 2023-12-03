defmodule GearRatios do
  def sum_part_numbers(file_name) do
    {schematic, height, width} = file_name |> setup |> schematic_with_dimensions

    parts_with_surroungings(file_name, height, width)
    |> part_numbers(schematic)
    |> Enum.map(&Enum.sum/1)
    |> Enum.sum()
  end

  def sum_gear_ratios(file_name) do
    {_schematic, height, width} = file_name |> setup |> schematic_with_dimensions

    gears(file_name)
    |> filter_gears(parts_with_surroungings(file_name, height, width) |> List.flatten())
    |> gear_ratio
    |> Enum.sum()
  end

  def schematic(list) do
    Enum.map(list, fn line -> String.split(line, "", trim: true) |> List.to_tuple() end)
    |> List.to_tuple()
  end

  def schematic_with_dimensions(list) do
    schematic(list)
    |> then(fn schematic -> {schematic, tuple_size(schematic), tuple_size(elem(schematic, 0))} end)
  end

  def parts_with_surroungings(file_name, height, width) do
    setup(file_name)
    |> items_with_column_and_length(~r/\d+/)
    |> parts_with_adjacent_symbols(height, width)
  end

  def items_with_column_and_length(list, re) do
    Enum.map(list, fn line ->
      items = Regex.scan(re, line) |> List.flatten()
      cols_and_lengths = Regex.scan(re, line, return: :index) |> List.flatten()
      Enum.zip(items, cols_and_lengths)
    end)
  end

  def parts_with_adjacent_symbols(numbers, height, width) do
    Enum.with_index(numbers)
    |> Enum.map(fn {line, row} ->
      Enum.map(line, fn {number, {col, len}} ->
        {number, adjacent_coordinates(row, {col, len}, height - 1, width - 1) |> List.flatten()}
      end)
    end)
  end

  def part_numbers(list, schematic) do
    Enum.map(list, fn line ->
      Enum.map(line, fn {part_number, locations} ->
        if Enum.any?(List.flatten(locations), fn coords ->
             !Regex.match?(~r/\d|\./, value(schematic, coords))
           end),
           do: elem(Integer.parse(part_number), 0),
           else: 0
      end)
    end)
  end

  def value(tuple_of_tuples, {row, col}) do
    elem(elem(tuple_of_tuples, row), col)
  end

  def adjacent_coordinates(row, {col, len}, max_row, max_col) do
    top = if row == 0, do: row, else: row - 1
    bottom = if row == max_row, do: row, else: row + 1
    left = if col == 0, do: col, else: col - 1
    right = if col + len >= max_col, do: max_col, else: col + (len - 1) + 1

    for r <- top..bottom,
        do:
          for(c <- left..right, do: {r, c})
          |> List.flatten()
  end

  def gears(file_name) do
    setup(file_name)
    |> items_with_column_and_length(~r/\*/)
    |> Enum.with_index()
    |> Enum.map(fn {line, index} ->
      Enum.map(line, fn asterisk ->
        {index, elem(elem(asterisk, 1), 0)}
      end)
    end)
    |> List.flatten()
  end

  def filter_gears(gears, parts_and_surroundings) do
    Enum.map(gears, fn gear ->
      Enum.filter(parts_and_surroundings, fn {_part, surrounding} ->
        Enum.member?(surrounding, gear)
      end)
    end)
  end

  def gear_ratio(gears) do
    Enum.map(gears, fn gear ->
      if length(gear) == 2,
        do:
          Enum.reduce(gear, 1, fn {part, _surrounding}, acc ->
            elem(Integer.parse(part), 0) * acc
          end),
        else: 0
    end)
  end

  def setup(file_name) do
    File.read!(file_name)
    |> String.split("\n")
  end
end
