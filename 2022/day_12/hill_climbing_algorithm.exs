defmodule HillClimbingAlgorithm do
  def heightmap do
    File.read!("input.txt")
    |> String.replace("S", "`")
    |> String.replace("E", "{")
    |> String.split("\n", trim: true)
    |> Enum.map(fn row -> String.split(row, "", trim: true) end)
  end

  def while(map, reduction, arrived?, destinations) when arrived? == false and destinations > 0 do
    round = Map.fetch!(reduction, :round)
    visit = Map.fetch!(reduction, :visit)
    visited = Map.fetch!(reduction, :visited)

    possible_moves =
      Enum.reduce(visit, %{}, fn {row, col}, possible_moves ->
        Map.put(possible_moves, {row - 1, col}, {row, col})
        |> Map.put({row + 1, col}, {row, col})
        |> Map.put({row, col - 1}, {row, col})
        |> Map.put({row, col + 1}, {row, col})
      end)

    to_visit =
      possible_moves
      |> Enum.reject(fn {to, _} ->
        MapSet.member?(visited, to)
      end)
      |> Enum.reject(fn {{trow, tcol}, _} ->
        trow < 0 or tcol < 0 or trow >= Enum.count(map) or tcol >= Enum.count(Enum.at(map, 0))
      end)
      |> Enum.reject(fn {{trow, tcol}, {frow, fcol}} ->
        Enum.at(Enum.at(map, trow), tcol) - Enum.at(Enum.at(map, frow), fcol) > 1 or
          (Enum.at(Enum.at(map, frow), fcol) >= 99 and
             Enum.at(Enum.at(map, trow), tcol) < Enum.at(Enum.at(map, frow), fcol))
      end)
      |> Enum.map(fn {to, _} -> to end)

    next_visited =
      Enum.reduce(to_visit, visited, fn move, visited -> MapSet.put(visited, move) end)

    reduction = %{
      round: round + 1,
      visit: to_visit,
      visited: next_visited
    }

    IO.inspect(round, label: :round)
    IO.inspect(to_visit, label: :to_visit)
    IO.inspect(MapSet.size(visited), label: :visited)
    IO.puts("\n")
    while(map, reduction, MapSet.member?(next_visited, {20, 72}), length(to_visit))
  end

  def while(_map, reduction, arrived?, destinations) when arrived? or destinations == 0 do
    Map.fetch!(reduction, :round)
    reduction
  end

  def steps_to_best_signal() do
    map = heightmap()

    Enum.each(map, fn row -> IO.puts(row) end)

    start =
      Enum.with_index(map)
      |> Enum.reduce_while({}, fn {row, rind}, coord ->
        cind = Enum.find_index(row, fn col -> col == '`' end)
        if is_number(cind), do: {:halt, {rind, cind}}, else: {:cont, {}}
      end)

    finish = 2

    IO.inspect(start, label: :start)
    IO.inspect(finish, label: :finish)

    square = {20, 0}

    reduction = %{
      round: 0,
      visit: [start],
      visited: MapSet.new([])
    }

    while(map, reduction, false, 1)
  end
end

HillClimbingAlgorithm.steps_to_best_signal() |> IO.inspect(label: "Steps to Best Signal")
