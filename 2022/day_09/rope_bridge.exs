defmodule RopeBridge do
  def head_movements do
    File.read!("input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Enum.map(fn move -> [Enum.at(move, 0), String.to_integer(Enum.at(move, 1))] end)
  end

  def touching?(head, tail) do
    {hx, hy} = head
    {tx, ty} = tail
    abs(hx - tx) <= 1 and abs(hy - ty) <= 1
  end

  def move(direction, mover) do
    {mx, my} = mover
    case direction do
      "D" -> {mx, my - 1}
      "L" -> {mx - 1, my}
      "R" -> {mx + 1, my}
      "U" -> {mx, my + 1}
    end
  end

  def direct(previous_knot, knot) do
    {hx, hy} = previous_knot
    {tx, ty} = knot
    cond do
      hx == tx and (hy - ty) <= -2 -> move("D", knot)
      (hx - tx) <= -2 and hy == ty -> move("L", knot)
      (hx - tx) >= 2 and hy == ty -> move("R", knot)
      hx == tx and (hy - ty) >= 2 -> move("U", knot)
      ((hx < tx) and (hy - ty) == -2) or ((hx - tx) == -2 and (hy < ty)) -> move("D", knot) |> then(&move("L", &1))
      ((hx > tx) and (hy - ty) == -2) or ((hx - tx) == 2 and (hy < ty)) -> move("D", knot) |> then(&move("R", &1))
      ((hx - tx) == -2 and (hy > ty)) or ((hx < tx) and (hy - ty) == 2) -> move("L", knot) |> then(&move("U", &1))
      ((hx - tx) == 2 and (hy > ty)) or ((hx > tx) and (hy - ty) == 2) -> move("R", knot) |> then(&move("U", &1))
    end
  end

  def previous(knot, index, knots) do
    previous_knot = Enum.at(knots, index - 1)
    cond do
      touching?(previous_knot, knot) -> knot
      true -> direct(previous_knot, knot)
    end
    |> then(&List.replace_at(knots, index, &1))
  end

  def motions(locations, direction) do
    locations[:knots]
    |> Enum.with_index()
    |> Enum.reduce(locations[:knots], fn {knot, index}, knots ->
      cond do
        index == 0 -> List.replace_at(knots, index, move(direction, knot))
        true -> previous(knot, index, knots)
      end
    end)
  end

  def moves(movement, locations) do
    [direction, steps] = movement
    Enum.reduce(1..steps, locations, fn _step, positions ->
      motions(positions, direction)
      |> then(&%{ knots: &1, visited: positions[:visited] ++ [List.last(&1)]})
    end)
  end

  def positions_visited(number_of_knots) do
    head_movements()
    |> Enum.reduce(%{knots: (for _x <- 1..number_of_knots, do: {0, 0}), visited: []},
    fn movement, positions -> moves(movement, positions) end)
    |> then(& &1[:visited])
    |> Enum.uniq()
    |> Enum.count()
  end
end

RopeBridge.positions_visited(2) |> IO.inspect(label: "Step 1")
RopeBridge.positions_visited(10) |> IO.inspect(label: "Step 2")
