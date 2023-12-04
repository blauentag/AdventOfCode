defmodule Scratchcards do
  def total_points(file_name) do
    numbers_prep(file_name)
    |> Enum.map(fn [winning_numbers, pool_numbers] ->
      MapSet.intersection(winning_numbers, pool_numbers) |> MapSet.size() |> score
    end)
    |> Enum.sum()
  end

  def total_scratch_cards(file_name) do
    numbers_prep(file_name)
    |> Enum.map(fn [winning_numbers, pool_numbers] ->
      MapSet.intersection(winning_numbers, pool_numbers) |> MapSet.size()
    end)
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {card, index}, acc ->
      extras =
        if card == 0,
          do: 0,
          else:
            1..card
            |> Range.to_list()
            |> Enum.reduce(0, fn extra, duplicates ->
              Map.get(acc, index - extra, 0) + duplicates
            end)

      Map.put(acc, index, 1 + extras)
    end)
    |> Map.values()
    |> Enum.sum()
  end

  def numbers_prep(file_name) do
    setup(file_name)
    |> Enum.map(fn line ->
      String.split(line, ": ", trim: true)
      |> List.last()
      |> String.split("|", trim: true)
      |> Enum.map(fn numbers -> String.split(numbers, " ", trim: true) |> MapSet.new() end)
    end)
  end

  def score(matching_numbers_count) do
    if matching_numbers_count == 0, do: 0, else: Integer.pow(2, matching_numbers_count - 1)
  end

  def setup(file_name) do
    File.read!(file_name) |> String.split("\n")
  end
end
