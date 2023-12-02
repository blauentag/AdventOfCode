defmodule CubeConundrum do
  def setup(file_name) do
    file_name
    |> File.read!()
    |> String.split("\n")
  end

  def sum_game_ids(file_name) do
    setup(file_name)
    |> Enum.with_index(1)
    |> Enum.map(fn {line, index} ->
      if Regex.match?(
           ~r/1[3-9] red|[2-9]\d+ red|1[4-9] green|[2-9]\d+ green|1[5-9] blue|[2-9]\d+ blue/,
           line
         ),
         do: 0,
         else: index
    end)
    |> Enum.sum()
  end

  def sum_of_power_of_fewest_cubes(file_name) do
    setup(file_name)
    |> transform_line_to_list_of_hand_strings
    |> Enum.map(fn list_of_hand_strings -> transform_hand_string_to_map(list_of_hand_strings) end)
    |> Enum.map(fn game -> merge_to_find_minimum_cube_count(game) end)
    |> Enum.map(fn counts_by_color -> Map.values(counts_by_color) end)
    |> Enum.map(fn counts -> Enum.reduce(counts, fn x, acc -> x * acc end) end)
    |> Enum.sum()
  end

  def transform_line_to_list_of_hand_strings(list) do
    Enum.map(list, fn line ->
      String.split(line, ": ", trim: true)
      |> Enum.drop(1)
      |> List.first()
      |> String.split("; ", trim: true)
    end)
  end

  def transform_hand_string_to_map(list_of_hand_strings) do
    Enum.flat_map(list_of_hand_strings, fn hand_as_string ->
      String.split(hand_as_string, ", ", trim: true)
      |> Enum.map(fn balls -> String.split(balls, " ", trim: true) end)
      |> Enum.map(fn balls -> %{List.last(balls) => elem(Integer.parse(List.first(balls)), 0)} end)
    end)
  end

  def merge_to_find_minimum_cube_count(game) do
    Enum.reduce(game, %{}, fn map, acc ->
      Map.merge(acc, map, fn _k, v1, v2 -> if v1 >= v2, do: v1, else: v2 end)
    end)
  end
end
