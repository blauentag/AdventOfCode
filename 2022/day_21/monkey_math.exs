defmodule MonkeyMath do
  def yells(file_name) do
    File.read!(file_name)
    |> String.split("\n", trim: true)
    |> Enum.map(fn monkey -> String.split(monkey, ": ", trim: true) end)
    |> Enum.reduce(%{}, fn [monkey, yell], monkeys ->
      Map.put(monkeys, monkey, yell)
    end)
    |> Enum.reduce(%{operation: %{}, number: %{}}, fn {key, value}, yells ->
      if Integer.parse(value) == :error do
        Map.replace(
          yells,
          :operation,
          Map.put(yells[:operation], key, String.split(value, " ", trim: true))
        )
      else
        Map.replace(yells, :number, Map.put(yells[:number], key, elem(Integer.parse(value), 0)))
      end
    end)
  end

  def find_numbers(numbers, operations) do
    Enum.reduce(operations, {numbers, operations}, fn {monkey, operation},
                                                      {numbers, operations} ->
      operation =
        Enum.map(operation, fn op ->
          Map.get(numbers, op, op)
        end)

      [first, op, last] = operation

      operation =
        if is_number(first) and is_number(last) do
          cond do
            op == "+" -> first + last
            op == "-" -> first - last
            op == "*" -> first * last
            op == "/" -> trunc(first / last)
          end
        else
          operation
        end

      if is_number(operation) do
        {Map.put(numbers, monkey, operation), Map.delete(operations, monkey)}
      else
        {numbers, operations}
      end
    end)
  end

  def crunch(number_yellers, operation_yellers, operations) when operations > 0 do
    {number_yellers, operation_yellers} = find_numbers(number_yellers, operation_yellers)
    crunch(number_yellers, operation_yellers, Enum.count(operation_yellers))
  end

  def crunch(number_yellers, operation_yellers, operations) when operations == 0 do
    {number_yellers, operation_yellers}
  end

  def yellers(file_name) do
    monkey_yells = yells(file_name)
    number_yellers = monkey_yells[:number]
    operation_yellers = monkey_yells[:operation]

    {number_yellers, operation_yellers}
  end

  def root(file_name) do
    {number_yellers, operation_yellers} = yellers(file_name)

    crunch(number_yellers, operation_yellers, Enum.count(operation_yellers))
    |> then(&elem(&1, 0))
    |> then(& &1["root"])
  end

  def bin_search(low, high, number_yellers, operation_yellers, difference) when difference != 0 do
    middle = trunc((high + low) / 2)
    number_yellers = Map.replace!(number_yellers, "humn", middle)

    {crunched_numbers, _} =
      crunch(number_yellers, operation_yellers, Enum.count(operation_yellers))

    root = Map.fetch!(crunched_numbers, "root")
    low = if root > 0, do: middle, else: low
    high = if root > 0, do: high, else: middle
    bin_search(low, high, number_yellers, operation_yellers, root)
  end

  def bin_search(low, high, _number_yellers, _operation_yellers, difference)
      when difference == 0 do
    trunc((high + low) / 2)
  end

  def humn(file_name) do
    {number_yellers, operation_yellers} = yellers(file_name)
    root = Map.fetch!(operation_yellers, "root")

    operation_yellers =
      Map.replace!(operation_yellers, "root", [Enum.at(root, 0), "-", Enum.at(root, -1)])

    bin_search(0, root(file_name), number_yellers, operation_yellers, 1)
  end
end

MonkeyMath.root("input.txt") |> IO.inspect(label: "Root yells")
MonkeyMath.humn("input.txt") |> IO.inspect(label: "I yell")
