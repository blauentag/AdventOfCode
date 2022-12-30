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
      String.trim(instructions)
      |> String.split("", trim: true)
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

  def find_next_valid_coord_cubed(map, row, col, facing) do
    if length(Tuple.to_list(map)) > 50 do
      Enum.reduce(0..49, %{}, fn step, map ->
        Map.put(map, {0, 50 + step, @up}, {150 + step, 0, @right})
        |> Map.put({150 + step, 0, @left}, {0, 50 + step, @down})
        |> Map.put({step, 50, @left}, {149 - step, 0, @right})
        |> Map.put({149 - step, 0, @left}, {step, 50, @right})
        |> Map.put({50 + step, 50, @left}, {100, step, @down})
        |> Map.put({100, step, @up}, {50 + step, 50, @right})
        |> Map.put({step, 149, @right}, {149 - step, 99, @left})
        |> Map.put({149 - step, 99, @right}, {step, 149, @left})
        |> Map.put({49, 100 + step, @down}, {50 + step, 99, @left})
        |> Map.put({50 + step, 99, @right}, {49, 100 + step, @up})
        |> Map.put({0, 100 + step, @up}, {199, step, @up})
        |> Map.put({199, step, @down}, {0, 100 + step, @down})
        |> Map.put({149, 50 + step, @down}, {150 + step, 49, @left})
        |> Map.put({150 + step, 49, @right}, {149, 50 + step, @up})
      end)
      |> Map.get({row, col, facing})
    else
      Enum.reduce(0..3, %{}, fn step, map ->
        Map.put(map, {0, 8 + step, @up}, {4, 3 - step, @down})
        |> Map.put({4, 3 - step, @up}, {0, 8 + step, @down})
        |> Map.put({step, 8, @left}, {4, 4 + step, @down})
        |> Map.put({4, 4 + step, @up}, {step, 8, @right})
        |> Map.put({step, 11, @right}, {11 - step, 15, @left})
        |> Map.put({11 - step, 15, @right}, {step, 11, @left})
        |> Map.put({4 + step, 0, @left}, {11, 15 - step, @up})
        |> Map.put({11, 15 - step, @down}, {4 + 1, 0, @right})
        |> Map.put({7, step, @down}, {11, 11 - step, @up})
        |> Map.put({11, 11 - step, @down}, {7, step, @up})
        |> Map.put({7, 4 + step, @down}, {11 - step, 8, @right})
        |> Map.put({11 - step, 8, @left}, {7, 4 + step, @up})
        |> Map.put({4 + step, 11, @right}, {8, 15 - step, @down})
        |> Map.put({8, 15 - step, @up}, {4 + step, 11, @left})
      end)
      |> Map.get({row, col, facing})
    end
  end

  def handle_landing_cubed(map, row, col, facing) do
    cubed_move = find_next_valid_coord_cubed(map, row, col, facing)

    {new_row, new_col, new_facing} =
      if is_nil(cubed_move) do
        cond do
          facing == @down ->
            {row + 1, col, @down}

          facing == @left ->
            {row, col - 1, @left}

          facing == @right ->
            {row, col + 1, @right}

          facing == @up ->
            {row - 1, col, @up}
        end
      else
        cubed_move
      end

    new_position = elem(elem(map, new_row), new_col)

    cond do
      new_position == "#" ->
        {row, col, facing}

      new_position == "." ->
        {new_row, new_col, new_facing}
    end
  end

  def move_cubed(map, row, col, facing, instruction) do
    if is_number(instruction) do
      Enum.reduce(1..instruction, {row, col, facing}, fn _, {row, col, facing} ->
        handle_landing_cubed(map, row, col, facing)
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

  def password_cubed(file_name) do
    {map, instructions} = map_and_instructions(file_name)

    Enum.reduce(
      instructions,
      {0, if(length(Tuple.to_list(map)) > 50, do: 50, else: 8), @right},
      fn instruction, {row, col, facing} ->
        move_cubed(map, row, col, facing, instruction)
      end
    )
    |> then(fn {row, col, facing} -> (row + 1) * 1000 + (col + 1) * 4 + facing end)
  end
end

MonkeyMap.final_password("input.txt") |> IO.inspect(label: :Step1)
MonkeyMap.password_cubed("input.txt") |> IO.inspect(label: :Step2)
