defmodule HillClimbingAlgorithm do
  def heightmap(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.map(fn row -> String.to_charlist(row) end)
  end

  def moves(point) do
    {row, col} = point

    %{
      {row - 1, col} => {row, col},
      {row + 1, col} => {row, col},
      {row, col - 1} => {row, col},
      {row, col + 1} => {row, col}
    }
  end

  def move_while(map, queue, visited, ending, part, moves_length) when moves_length > 0 do
    moves =
      List.last(queue)
      |> Enum.map(fn positions -> moves(positions) end)
      |> Enum.map(fn moves_grp ->
        Enum.reject(moves_grp, fn {{row, col}, _from} ->
          row < 0 or col < 0 or row >= Enum.count(map) or col >= Enum.count(Enum.at(map, 0))
        end)
      end)
      |> Enum.map(fn moves_map ->
        Enum.reject(moves_map, fn {{mrow, mcol}, {crow, ccol}} ->
          Enum.at(Enum.at(map, mrow), mcol) > Enum.at(Enum.at(map, crow), ccol) + 1
        end)
      end)
      |> Enum.map(fn moves_list ->
        Enum.reduce(moves_list, %{}, fn {to, from}, moves_map ->
          Map.merge(moves_map, %{to => from})
        end)
      end)
      |> Enum.reduce(%{}, fn move_map, moves -> Map.merge(moves, move_map) end)
      |> Enum.map(fn {to, _} -> to end)
      |> Enum.reject(fn move -> MapSet.member?(visited, move) end)

    queue = List.insert_at(queue, -1, moves)
    visited = MapSet.union(visited, MapSet.new(moves))

    Enum.map(List.last(queue), fn {row, col} -> Enum.at(Enum.at(map, row), col) end)

    move_while(map, queue, visited, ending, part, length(moves))
  end

  def move_while(_, queue, _, ending, part, moves_length)
      when moves_length == 0 and part == 1 do
    Enum.find_index(queue, fn moves -> Enum.member?(moves, ending) end)
  end

  def move_while(map, queue, _, ending, part, moves_length)
      when moves_length == 0 and part == 2 do
    Enum.find_index(queue, fn moves ->
      values = Enum.map(moves, fn {row, col} -> Enum.at(Enum.at(map, row), col) end)
      {erow, ecol} = ending
      Enum.member?(values, Enum.at(Enum.at(map, erow), ecol))
    end)
  end

  def steps_to_best_signal(filename) do
    map = heightmap(filename)

    start =
      Enum.with_index(map)
      |> Enum.reduce_while({}, fn {row, rind}, _ ->
        cind = Enum.find_index(row, fn col -> col == 83 end)
        if is_number(cind), do: {:halt, {rind, cind}}, else: {:cont, {}}
      end)

    ending =
      Enum.with_index(map)
      |> Enum.reduce_while({}, fn {row, rind}, _ ->
        cind = Enum.find_index(row, fn col -> col == 69 end)
        if is_number(cind), do: {:halt, {rind, cind}}, else: {:cont, {}}
      end)

    map =
      Enum.map(map, fn row ->
        Enum.map(row, fn col ->
          cond do
            col == 83 -> 97
            col == 69 -> 122
            true -> col
          end
        end)
      end)

    move_while(map, [[start]], MapSet.new([]), ending, 1, 1)
  end

  def best_hiking_trail(filename) do
    map = heightmap(filename)

    start =
      Enum.with_index(map)
      |> Enum.reduce_while({}, fn {row, rind}, _ ->
        cind = Enum.find_index(row, fn col -> col == 69 end)
        if is_number(cind), do: {:halt, {rind, cind}}, else: {:cont, {}}
      end)

    ending =
      Enum.with_index(map)
      |> Enum.reduce_while({}, fn {row, rind}, _ ->
        cind = Enum.find_index(row, fn col -> col == 83 end)
        if is_number(cind), do: {:halt, {rind, cind}}, else: {:cont, {}}
      end)

    map =
      Enum.map(map, fn row ->
        Enum.map(row, fn col ->
          cond do
            col == 83 -> abs(97 - 122) + 97
            col == 69 -> abs(122 - 122) + 97
            true -> abs(col - 122) + 97
          end
        end)
      end)

    move_while(map, [[start]], MapSet.new([]), ending, 2, 1)
  end
end

HillClimbingAlgorithm.steps_to_best_signal("input.txt")
|> IO.inspect(label: "Steps to Best Signal")

HillClimbingAlgorithm.best_hiking_trail("input.txt") |> IO.inspect(label: "Steps to Best Signal")
