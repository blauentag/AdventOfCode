defmodule MirageMaintenance do
  def sum_extrapolated_values(file_name, part_1) do
    _setup(file_name)
    |> Enum.map(&_extrapolate(&1, part_1)) |> IO.inspect
    |> Enum.sum
  end

  defp _extrapolate(sequence, part_1), do: _extrapolate({sequence, false}, 0, part_1)
  defp _extrapolate({_, true}, acc, part_1), do: (if part_1, do: acc, else: -acc)
  defp _extrapolate({sequence, false}, acc, part_1) do
    _differences(sequence) |> then(& _extrapolate(&1, _acc(sequence, acc, part_1), part_1))
  end

  defp _acc(sequence, acc, part_1) do
    if part_1, do: List.last(sequence) + acc, else: List.first(sequence) - acc
  end

  defp _differences(sequence) do
    Enum.zip(Enum.slice(sequence, 1..-1), Enum.slice(sequence, 0..-2))
    |> Enum.map(fn {larger, smaller} -> larger - smaller end)
    |> then(& {&1, Enum.all?(&1, fn n -> n == 0 end)})
  end

  defp _setup(file_name) do
    File.read!(file_name)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> String.split(line, " ", trim: true) end)
    |> Enum.map(fn line -> Enum.map(line, fn num -> Integer.parse(num) |> elem(0) end) end)
  end
end
