defmodule BlizzardBasin do
  @arrows MapSet.new(["<", ">", "^", "v"])

  def scan(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
    |> Enum.with_index()
    |> Enum.reduce([], fn {line, row}, blizzards ->
      Enum.with_index(line)
      |> Enum.reduce(blizzards, fn {icon, col}, storms ->
        if MapSet.member?(@arrows, icon), do: [{{row - 1, col - 1}, icon} | storms], else: storms
      end)
    end)
  end

  def blizzards_move(blizzard_map, height, width) do
    Enum.reduce(blizzard_map, [], fn {{row, col}, direction}, map_t ->
      {{d_row, d_col}, d_direction} =
        cond do
          direction == "^" -> {{Integer.mod(row - 1, height), col}, direction}
          direction == "v" -> {{Integer.mod(row + 1, height), col}, direction}
          direction == "<" -> {{row, Integer.mod(col - 1, width)}, direction}
          direction == ">" -> {{row, Integer.mod(col + 1, width)}, direction}
        end

      [{{d_row, d_col}, d_direction} | map_t]
    end)
  end

  def open_positions(valley_map, blizzard_map) do
    MapSet.difference(
      valley_map,
      MapSet.new(Enum.map(blizzard_map, fn {location, _} -> location end))
    )
  end

  def move(blizzard_map, queue, valley_map, height, width, row, direction)
      when (row < height and direction == :down) or (row >= 0 and direction == :up) do
    moves = List.last(queue)
    blizzard_map = blizzards_move(blizzard_map, height, width)
    current_open_positions = open_positions(valley_map, blizzard_map)

    moves_possible =
      Enum.reduce(moves, [], fn {row, col}, possible_moves ->
        List.insert_at(
          possible_moves,
          -1,
          MapSet.intersection(
            current_open_positions,
            MapSet.new([
              {row + 1, col},
              {row, col + 1},
              {row - 1, col},
              {row, col - 1},
              {row, col}
            ])
          )
        )
      end)

    moves_possible =
      Enum.map(moves_possible, fn moves_ms -> MapSet.to_list(moves_ms) end)
      |> List.flatten()
      |> MapSet.new()
      |> MapSet.to_list()

    row_goal =
      if direction == :down,
        do: Enum.max(Enum.map(moves_possible, fn {row, _} -> row end)),
        else: Enum.min(Enum.map(moves_possible, fn {row, _} -> row end))

    queue = List.insert_at(queue, -1, moves_possible)
    move(blizzard_map, queue, valley_map, height, width, row_goal, direction)
  end

  def move(blizzard_map, queue, _, height, _, row, direction)
      when row >= height and direction == :down do
    {length(queue) - 1, blizzard_map}
  end

  def move(blizzard_map, queue, _, _, _, row, direction)
      when row < 0 and direction == :up do
    {length(queue) - 1, blizzard_map}
  end

  def minutes_to_goal(initial_blizzard_map, direction) do
    {min_row, max_row} =
      Enum.map(initial_blizzard_map, fn {{row, _}, _} -> row end)
      |> Enum.min_max()

    {min_col, max_col} =
      Enum.map(initial_blizzard_map, fn {{_, col}, _} -> col end)
      |> Enum.min_max()

    height = max_row - min_row + 1
    width = max_col - min_col + 1
    start = if direction == :down, do: {-1, min_col}, else: {height, max_col}
    finish = if direction == :down, do: {height, max_col}, else: {-1, min_col}
    queue = [[start]]

    valley_map =
      Enum.reduce(min_row..max_row, MapSet.new([start, finish]), fn row, row_set ->
        Enum.reduce(min_col..max_col, row_set, fn col, col_set ->
          MapSet.put(col_set, {row, col})
        end)
      end)

    move(initial_blizzard_map, queue, valley_map, height, width, min_row, direction)
  end

  def there(filename) do
    minutes_to_goal(scan(filename), :down)
  end

  def back_and_there_again(step_1) do
    {total_time, blizzard_map} = step_1
    {minutes, blizzard_map} = minutes_to_goal(blizzard_map, :up)
    total_time = total_time + minutes
    {minutes, _} = minutes_to_goal(blizzard_map, :down)
    total_time + minutes
  end
end

System.argv()
|> then(&if &1 == [], do: IO.read(:all), else: List.first(&1))
|> String.trim()
|> BlizzardBasin.there()
|> Tuple.to_list()
|> Enum.reduce({}, fn elem, tuple ->
  if is_number(elem), do: IO.inspect(elem, label: :Step1)
  Tuple.append(tuple, elem)
end)
|> BlizzardBasin.back_and_there_again()
|> IO.inspect(label: :Step2)
