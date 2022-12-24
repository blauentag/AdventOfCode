defmodule UnstableDiffusion do
  @part1 1
  @part2 2

  @moves [
    [{-1, -1}, {-1, 0}, {-1, 1}],
    [{1, -1}, {1, 0}, {1, 1}],
    [{-1, -1}, {0, -1}, {1, -1}],
    [{-1, 1}, {0, 1}, {1, 1}]
  ]

  def scan(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
    |> Enum.with_index()
    |> Enum.reduce(MapSet.new(), fn {row, row_index}, grid ->
      Enum.with_index(row)
      |> Enum.reduce(grid, fn {col, col_index}, grid ->
        if col == "#", do: MapSet.put(grid, {row_index, col_index}), else: grid
      end)
    end)
  end

  def move(grid, round, moves, part)
      when (moves > 0 and part == @part2) or (round < 10 and part == @part1) do
    possible_moves =
      Enum.reduce(grid, %{}, fn {row, col}, possible_next_moves ->
        moves =
          if Enum.reduce(-1..1, 0, fn d_row, elves ->
               Enum.reduce(-1..1, elves, fn d_col, elves ->
                 if MapSet.member?(grid, {row + d_row, col + d_col}),
                   do: elves + 1,
                   else: elves + 0
               end)
             end) > 1 do
            Enum.reduce_while(0..3, possible_next_moves, fn directional_index, next_moves ->
              possible_direction =
                Enum.map(Enum.at(@moves, Integer.mod(directional_index + round, 4)), fn delta ->
                  {d_row, d_col} = delta
                  {row + d_row, col + d_col}
                end)

              if MapSet.disjoint?(grid, MapSet.new(possible_direction)) do
                {:halt,
                 Map.merge(
                   next_moves,
                   %{Enum.at(possible_direction, 1) => [{row, col}]},
                   fn _k, v1, v2 -> v1 ++ v2 end
                 )}
              else
                {:cont, next_moves}
              end
            end)
          else
            possible_next_moves
          end

        Map.merge(possible_next_moves, moves)
      end)

    move_count = Enum.count(possible_moves)

    Enum.reduce(possible_moves, grid, fn {to, froms}, grid ->
      if length(froms) == 1 do
        from = Enum.at(froms, 0)

        MapSet.put(grid, to)
        |> MapSet.delete(from)
      else
        grid
      end
    end)
    |> move(round + 1, move_count, part)
  end

  def move(grid, round, moves, part)
      when (moves == 0 and part == @part2) or (round == 10 and part == @part1) do
    case part do
      @part1 -> grid
      @part2 -> round
    end
  end

  def score(grid) do
    row = Enum.min_max(Enum.map(grid, fn coord -> elem(coord, 0) end))
    col = Enum.min_max(Enum.map(grid, fn coord -> elem(coord, 1) end))
    (elem(row, 1) - elem(row, 0) + 1) * (elem(col, 1) - elem(col, 0) + 1) - MapSet.size(grid)
  end

  def empty_tiles_in_rectangle(filename) do
    scan(filename)
    |> move(0, 1, @part1)
    |> score()
  end

  def round_no_elf_moves(filename) do
    scan(filename)
    |> move(0, 1, @part2)
  end
end

UnstableDiffusion.empty_tiles_in_rectangle("input.txt") |> IO.inspect(label: :Step1)
UnstableDiffusion.round_no_elf_moves("input.txt") |> IO.inspect(label: :Step2)
