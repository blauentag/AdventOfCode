[4, 2, 2, 1, 0, 0]
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

  IO.puts("card: #{card},\tindex: #{index},\textras: #{extras}")

  Map.put(acc, index, 1 + extras)
  |> IO.inspect()
end)
|> Map.values()
|> Enum.sum()
|> IO.inspect()

# [0, 1, 2, 3,  4,  5]
# [0, 0, 1, 2,  2,  4]
# [1, 1, 3, 7, 13, 30]
