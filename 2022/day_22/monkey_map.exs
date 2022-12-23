defmodule MonkeyMap do
  @down 1
  @left 2
  @right 0
  @up 3
  @directions [@right, @down, @left, @up]

  def map_and_instructions(file_name) do
    [map, instructions] =
      File.read!(file_name)
      |> String.split("\n\n", trim: true)

    map =
      String.split(map, "\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))
      |> Enum.map(fn row ->
        Enum.map(row, fn coord -> if coord == " ", do: "", else: coord end)
      end)

    length_of_widest_map_row =
      Enum.map(map, fn row -> length(row) end)
      |> Enum.max()

    map =
      Enum.map(map, fn row ->
        if length(row) < length_of_widest_map_row do
          row ++ for _ <- 1..(length_of_widest_map_row - length(row)), do: ""
        else
          row
        end
      end)
      |> Enum.map(fn row -> List.to_tuple(row) end)
      |> List.to_tuple()

    instructions =
      String.split(instructions, "", trim: true)
      |> Enum.map(fn instruction ->
        if Regex.match?(~r{\A(\d+|-\d+)\z}, instruction),
          do: instruction,
          else: ",#{instruction},"
      end)
      |> List.to_string()
      |> String.split(",", trim: true)
      |> Enum.map(fn instruction ->
        if Regex.match?(~r{\A(\d+|-\d+)\z}, instruction),
          do: String.to_integer(instruction),
          else: instruction
      end)

    {map, instructions}
  end

  def find_next_valid_coord(map, row, col, facing, height, width) do
    cond do
      facing == @down ->
        Enum.reduce_while(0..height, {row, col, facing}, fn _, {row, col, facing} ->
          if elem(elem(map, row), col) == "",
            do: {:cont, {Integer.mod(row + 1, height), col, facing}},
            else: {:halt, {row, col, facing}}
        end)

      facing == @left ->
        Enum.reduce_while(0..width, {row, col, facing}, fn _, {row, col, facing} ->
          if elem(elem(map, row), col) == "",
            do: {:cont, {row, Integer.mod(col - 1, width), facing}},
            else: {:halt, {row, col, facing}}
        end)

      facing == @right ->
        Enum.reduce_while(0..width, {row, col, facing}, fn _, {row, col, facing} ->
          if elem(elem(map, row), col) == "",
            do: {:cont, {row, Integer.mod(col + 1, width), facing}},
            else: {:halt, {row, col, facing}}
        end)

      facing == @up ->
        Enum.reduce_while(0..height, {row, col, facing}, fn _, {row, col, facing} ->
          if elem(elem(map, row), col) == "",
            do: {:cont, {Integer.mod(row - 1, height), col, facing}},
            else: {:halt, {row, col, facing}}
        end)
    end
  end

  def handle_landing(map, row, col, facing) do
    height = tuple_size(map)
    width = tuple_size(elem(map, 0))

    {new_row, new_col, facing} =
      cond do
        facing == @down -> {Integer.mod(row + 1, height), col, facing}
        facing == @left -> {row, Integer.mod(col - 1, width), facing}
        facing == @right -> {row, Integer.mod(col + 1, width), facing}
        facing == @up -> {Integer.mod(row - 1, height), col, facing}
      end

    new_position = elem(elem(map, new_row), new_col)

    cond do
      new_position == "#" ->
        {row, col, facing}

      new_position == "." ->
        {new_row, new_col, facing}

      new_position == "" ->
        {new_row, new_col, facing} =
          find_next_valid_coord(map, new_row, new_col, facing, height, width)

        if elem(elem(map, new_row), new_col) == "#",
          do: {row, col, facing},
          else: {new_row, new_col, facing}
    end
  end

  def move(map, row, col, facing, instruction) do
    if is_number(instruction) do
      Enum.reduce(1..instruction, {row, col, facing}, fn _, {row, col, facing} ->
        handle_landing(map, row, col, facing)
      end)
    else
      facing =
        cond do
          instruction == "R" -> Enum.at(@directions, Integer.mod(facing + 1, 4))
          instruction == "L" -> Enum.at(@directions, Integer.mod(facing - 1, 4))
          true -> facing
        end

      {row, col, facing}
    end
  end

  def final_password(file_name) do
    {map, instructions} = map_and_instructions(file_name)

    Enum.reduce(instructions, {0, 50, @right}, fn instruction, {row, col, facing} ->
      move(map, row, col, facing, instruction)
    end)
    |> then(fn {row, col, facing} -> (row + 1) * 1000 + (col + 1) * 4 + facing end)
  end
end

MonkeyMap.final_password("input.txt") |> IO.inspect(label: :Step1)
