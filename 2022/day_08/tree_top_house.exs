defmodule TreeTopHouse do
  def tree_map do
    File.read!("input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
    |> Enum.map(&Enum.map(&1, fn num -> String.to_integer(num) end))
  end

  def dimensions(tree_map) do
    height = Enum.count(tree_map) - 1
    width = Enum.count(Enum.at(tree_map, 0)) - 1
    {height, width}
  end

  def hidden_down?(tree_map, row, col) do
    {height, _width} = dimensions(tree_map)
    tree_height = Enum.at(Enum.at(tree_map, row), col)
    Enum.reduce_while((row + 1)..height, false, fn r, _acc -> if tree_height <= Enum.at(Enum.at(tree_map, r), col), do: {:halt, true}, else: {:cont, false} end)
  end

  def hidden_left?(tree_map, row, col) do
    tree_height = Enum.at(Enum.at(tree_map, row), col)
    Enum.reduce_while((col - 1)..0, false, fn c, _acc -> if tree_height > Enum.at(Enum.at(tree_map, row), c), do: {:cont, false}, else: {:halt, true} end)
  end

  def hidden_right?(tree_map, row, col) do
    {_height, width} = dimensions(tree_map)
    tree_height = Enum.at(Enum.at(tree_map, row), col)
    Enum.reduce_while((col + 1)..width, false, fn c, _acc -> if tree_height <= Enum.at(Enum.at(tree_map, row), c), do: {:halt, true}, else: {:cont, false} end)
  end

  def hidden_up?(tree_map, row, col) do
    tree_height = Enum.at(Enum.at(tree_map, row), col)
    Enum.reduce_while((row - 1)..0, false, fn r, _acc -> if tree_height > Enum.at(Enum.at(tree_map, r), col), do: {:cont, false}, else: {:halt, true} end)
  end

  def count(tree_map, row, width) do
    {height, _width} = dimensions(tree_map)
    Enum.reduce(0..width, %{hidden: 0, visible: 0}, fn col, acc ->
      if (row == 0 or col == 0 or row == height or col == width) do
        Map.update!(acc, :visible, fn visible -> visible + 1 end)
      else
        if (hidden_down?(tree_map, row, col) and hidden_left?(tree_map, row, col) and hidden_right?(tree_map, row, col) and hidden_up?(tree_map, row, col)) do
          Map.update!(acc, :hidden, fn h -> h + 1 end)
        else
          Map.update!(acc, :visible, fn v -> v + 1 end)
        end
      end
    end)
  end

  def visible_trees(tree_map) do
    {height, width} = dimensions(tree_map)
    Enum.reduce(0..height, %{hidden: 0, visible: 0}, fn row, acc ->
      row_counts = count(tree_map, row, width)
      Map.merge(acc, row_counts, fn _k, v1, v2 -> v1 + v2 end)
    end)
    |> Map.get(:visible)
  end

  def trees_down(tree_map, row, col) do
    {height, _width} = dimensions(tree_map)
    tree_height = Enum.at(Enum.at(tree_map, row), col)
    Enum.reduce_while((row + 1)..height, 1, fn r, acc ->
      if (tree_height > Enum.at(Enum.at(tree_map, r), col) and r != height), do: {:cont, acc + 1}, else: {:halt, acc + 0}
    end)
  end

  def trees_left(tree_map, row, col) do
    tree_height = Enum.at(Enum.at(tree_map, row), col)
    Enum.reduce_while((col - 1)..0, 1, fn c, acc ->
      if (tree_height > Enum.at(Enum.at(tree_map, row), c) and c != 0), do: {:cont, acc + 1}, else: {:halt, acc + 0}
    end)
  end

  def trees_right(tree_map, row, col) do
    {_height, width} = dimensions(tree_map)
    tree_height = Enum.at(Enum.at(tree_map, row), col)
    Enum.reduce_while((col + 1)..width, 1, fn c, acc ->
      if (tree_height > Enum.at(Enum.at(tree_map, row), c) and c != width), do: {:cont, acc + 1}, else: {:halt, acc + 0}
    end)
  end

  def trees_up(tree_map, row, col) do
    tree_height = Enum.at(Enum.at(tree_map, row), col)
    Enum.reduce_while((row - 1)..0, 1, fn r, acc ->
      if (tree_height > Enum.at(Enum.at(tree_map, r), col) and r != 0), do: {:cont, acc + 1}, else: {:halt, acc + 0}
    end)
  end

  def score(tree_map, row, width) do
    {height, _width} = dimensions(tree_map)
    Enum.reduce(0..width, 0, fn col, acc ->
      if (row != 0 and col != 0 and row != height and col != width) do
        scenic_score = trees_down(tree_map, row, col) * trees_left(tree_map, row, col) * trees_right(tree_map, row, col) * trees_up(tree_map, row, col)
        if scenic_score > acc do
          scenic_score
        else
          acc + 0
        end
      else
        acc + 0
      end
    end)
  end

  def best_scenic_score(tree_map) do
    {height, width} = dimensions(tree_map)
    Enum.reduce(0..height, 0, fn row, acc ->
      scenic_score = score(tree_map, row, width)
      if scenic_score > acc do
        scenic_score
      else
        acc
      end
    end)
  end
end

TreeTopHouse.visible_trees(TreeTopHouse.tree_map()) |> IO.inspect(label: "Step 1")
TreeTopHouse.best_scenic_score(TreeTopHouse.tree_map()) |> IO.inspect(label: "Step 2")
