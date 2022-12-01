defmodule HydrothermalLines do
  def diagonal?(coords) do
    abs(elem(elem(coords, 0), 0) - elem(elem(coords, 1), 0)) == abs(elem(elem(coords, 0), 1) - elem(elem(coords, 1), 1))
  end

  def horizontal?(coords) do
    elem(elem(coords, 0), 1) == elem(elem(coords, 1), 1)
  end

  def vertical?(coords) do
    elem(elem(coords, 0), 0) == elem(elem(coords, 1), 0)
  end

  def flatten([head | tail]), do: flatten(head) ++ flatten(tail)
  def flatten([]), do: []
  def flatten(element), do: [element]
end

contents = File.stream!("./input.txt")
    |> Stream.map(&String.trim_trailing/1)
    |> Enum.to_list
    |> Enum.map(fn line -> String.split(line, " -> ") end)

lines = for [beg_coord, end_coord] <- contents,
  do: {List.to_tuple(Enum.map(String.split(beg_coord, ","), &String.to_integer/1)),
  List.to_tuple(Enum.map(String.split(end_coord, ","), &String.to_integer/1))}

hydrothermal_map = HydrothermalLines.flatten(Enum.map(lines, fn line ->
    cond do
      HydrothermalLines.diagonal?(line) ->
        ud_inc = if elem(elem(line, 0), 0) < elem(elem(line, 1), 0), do: 1, else: -1
        lr_inc = if elem(elem(line, 0), 1) < elem(elem(line, 1), 1), do: 1, else: -1
        ud = [elem(elem(line, 0), 0), elem(elem(line, 1), 0)]
        lr = [elem(elem(line, 0), 1), elem(elem(line, 1), 1)]
        ud_beg = if ud_inc < 0, do: Enum.max(ud), else: Enum.min(ud)
        lr_beg = if lr_inc < 0, do: Enum.max(lr), else: Enum.min(lr)
        distance = abs(elem(elem(line, 0), 0) - elem(elem(line, 1), 0))

        Enum.map(0..distance, fn (step) ->
          point = {ud_beg + (ud_inc * step), lr_beg + (lr_inc * step)}
          %{point => 1}
        end)

      HydrothermalLines.horizontal?(line) ->
        distance = [elem(elem(line, 0), 0), elem(elem(line, 1), 0)]
        max = Enum.reduce(distance, &max/2)
        min = Enum.reduce(distance, &min/2)
        Enum.map(min..max, fn (step) ->
          point = {step, elem(elem(line, 0), 1)}
          %{point => 1}
        end)

      HydrothermalLines.vertical?(line) ->
        distance = [elem(elem(line, 0), 1), elem(elem(line, 1), 1)]
        max = Enum.reduce(distance, &max/2)
        min = Enum.reduce(distance, &min/2)

        Enum.map(min..max, fn (step) ->
          point = {elem(elem(line, 0), 0), step}
          %{point => 1}
        end)

      true ->
        nil
    end
  end))
  |> Enum.reject( &is_nil/1)
  |> Enum.reduce(%{}, fn (point, map) ->
       Map.merge(map, point, fn (_key, v1, v2) -> v1 + v2 end)
     end)

IO.inspect(Enum.count(Map.values(hydrothermal_map), fn (val) -> val >= 2 end))
