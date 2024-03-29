input =
  Path.join(__DIR__, "input.txt")
  |> File.stream!()
  |> Stream.map(fn line ->
    line
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end)

defmodule SideCounter do
  def count_sides(cubes) do
    cubes = MapSet.new(cubes)

    for cube <- cubes, reduce: 0 do
      sum -> sum + count_sides(cube, cubes)
    end
  end

  @vectors [
    {1, 0, 0},
    {-1, 0, 0},
    {0, 1, 0},
    {0, -1, 0},
    {0, 0, 1},
    {0, 0, -1}
  ]
  def count_sides(cube, cubes) do
    for offset <- @vectors, reduce: 0 do
      sum ->
        if MapSet.member?(cubes, translate(cube, offset)) do
          sum
        else
          sum + 1
        end
    end
  end

  defp translate({x, y, z}, {dx, dy, dz}) do
    {x + dx, y + dy, z + dz}
  end
end

part1 = SideCounter.count_sides(input)
IO.inspect(part1, label: "Part 1")

defmodule FloodFiller do
  def flood(input) do
    cubes = MapSet.new(input)
    inverted = invert(cubes)
    outershell = collect_connected({-1, -1, -1}, inverted)

    MapSet.difference(inverted, outershell)
  end

  defp invert(cubes) do
    {mx, my, mz} = bounds(cubes)

    for x <- -1..(mx + 1), y <- -1..(my + 1), z <- -1..(mz + 1), reduce: MapSet.new() do
      empty ->
        pos = {x, y, z}

        if MapSet.member?(cubes, pos) do
          empty
        else
          empty |> MapSet.put(pos)
        end
    end
  end

  @vectors [
    {1, 0, 0},
    {-1, 0, 0},
    {0, 1, 0},
    {0, -1, 0},
    {0, 0, 1},
    {0, 0, -1}
  ]

  defp bounds(cubes) do
    for {x, y, z} <- cubes, reduce: {0, 0, 0} do
      {mx, my, mz} -> {max(mx, x), max(my, y), max(mz, z)}
    end
  end

  defp translate({x, y, z}, {dx, dy, dz}) do
    {x + dx, y + dy, z + dz}
  end

  defp collect_connected(pos, cubes) do
    collect_connected(pos, cubes, MapSet.new())
  end

  defp collect_connected(pos, cubes, visited) do
    for offset <- @vectors, reduce: visited do
      visited ->
        neighboor = translate(pos, offset)

        if MapSet.member?(cubes, neighboor) && !MapSet.member?(visited, neighboor) do
          collect_connected(neighboor, cubes, MapSet.put(visited, neighboor))
        else
          visited
        end
    end
  end
end

interior_size =
  FloodFiller.flood(input)
  |> SideCounter.count_sides()

part2 = part1 - interior_size

IO.inspect(part2, label: "Part 2")
