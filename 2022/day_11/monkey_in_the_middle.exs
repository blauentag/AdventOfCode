defmodule MonkeyInTheMiddle do
  def monkeys do
    File.read!("input.txt")
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn monkey -> String.split(monkey, "\n", trim: true) end)
    |> Enum.map(fn monkey -> initialize(monkey) end)
  end

  def initialize(monkey) do
    monkey
    |> Enum.with_index()
    |> Enum.reduce(%{inspections: 0}, fn line_index, monkey ->
      {line, index} = line_index

      cond do
        index == 0 ->
          monkey

        index == 1 ->
          Map.merge(monkey, %{
            items:
              String.replace(line, "  Starting items: ", "")
              |> String.split(", ")
              |> Enum.map(&String.to_integer(&1))
          })

        index == 2 ->
          Map.merge(monkey, %{
            operation: String.replace(line, "  Operation: new = old ", "") |> String.split()
          })

        index == 3 ->
          Map.merge(monkey, %{
            test: String.replace(line, "  Test: divisible by ", "") |> String.to_integer()
          })

        index == 4 ->
          Map.merge(monkey, %{true: String.slice(line, -1..-1) |> String.to_integer()})

        index == 5 ->
          Map.merge(monkey, %{false: String.slice(line, -1..-1) |> String.to_integer()})
      end
    end)
  end

  def monkey_business do
    monkeys = monkeys()

    1..20
    |> Enum.reduce(monkeys, fn _, monkeys ->
      monkeys
      |> Enum.with_index()
      |> Enum.reduce(monkeys, fn indexed_monkey, monkeys ->
        turn(monkeys, elem(indexed_monkey, 1))
      end)
    end)
    |> Enum.sort_by(&Map.get(&1, :inspections), :desc)
    |> Enum.take(2)
    |> Enum.map(fn monkey -> monkey[:inspections] end)
    |> Enum.product()
  end

  def operate(item, operation) do
    [operator, number] = operation

    number =
      if Regex.match?(~r{\A(\d+|-\d+)\z}, number), do: String.to_integer(number), else: item

    cond do
      operator == "+" -> item + number
      operator == "*" -> item * number
    end
    |> then(&floor(&1 / 3))
  end

  def turn(monkeys, monkey_index) do
    Enum.at(monkeys, monkey_index)[:items]
    |> Enum.with_index()
    |> Enum.reduce(monkeys, fn indexed_item, monkeys ->
      {item, _index} = indexed_item
      monkey = Enum.at(monkeys, monkey_index)
      worry_level = operate(item, monkey[:operation])

      to_monkey_index =
        cond do
          Integer.mod(worry_level, monkey[:test]) == 0 -> monkey[true]
          true -> monkey[false]
        end

      to_monkey = Enum.at(monkeys, to_monkey_index)

      to_monkey =
        Map.replace!(to_monkey, :items, List.insert_at(to_monkey[:items], -1, worry_level))

      monkey =
        Map.merge(monkey, %{
          items: List.delete_at(monkey[:items], 0),
          inspections: monkey[:inspections] + 1
        })

      List.replace_at(monkeys, monkey_index, monkey)
      |> List.replace_at(to_monkey_index, to_monkey)
    end)
  end

  def monkey_business_10k do
    monkeys = monkeys()
    product = Enum.map(monkeys, fn monkey -> Map.fetch!(monkey, :test) end) |> Enum.product()

    1..10_000
    |> Enum.reduce(monkeys, fn _, monkeys ->
      monkeys
      |> Enum.with_index()
      |> Enum.reduce(monkeys, fn indexed_monkey, monkeys ->
        turn(monkeys, elem(indexed_monkey, 1), product)
      end)
    end)
    |> Enum.sort_by(&Map.get(&1, :inspections), :desc)
    |> Enum.take(2)
    |> Enum.map(fn monkey -> monkey[:inspections] end)
    |> Enum.product()
  end

  def operate(item, operation, product) do
    [operator, number] = operation

    number =
      if Regex.match?(~r{\A(\d+|-\d+)\z}, number), do: String.to_integer(number), else: item

    cond do
      operator == "+" -> item + number
      operator == "*" -> item * number
    end
    |> then(&Integer.mod(&1, product))
  end

  def turn(monkeys, monkey_index, product) do
    Enum.at(monkeys, monkey_index)[:items]
    |> Enum.with_index()
    |> Enum.reduce(monkeys, fn indexed_item, monkeys ->
      {item, _index} = indexed_item
      monkey = Enum.at(monkeys, monkey_index)
      worry_level = operate(item, monkey[:operation], product)

      to_monkey_index =
        cond do
          Integer.mod(worry_level, monkey[:test]) == 0 -> monkey[true]
          true -> monkey[false]
        end

      to_monkey = Enum.at(monkeys, to_monkey_index)

      to_monkey =
        Map.replace!(to_monkey, :items, List.insert_at(to_monkey[:items], -1, worry_level))

      monkey =
        Map.merge(monkey, %{
          items: List.delete_at(monkey[:items], 0),
          inspections: monkey[:inspections] + 1
        })

      List.replace_at(monkeys, monkey_index, monkey)
      |> List.replace_at(to_monkey_index, to_monkey)
    end)
  end
end

MonkeyInTheMiddle.monkey_business() |> IO.inspect()
MonkeyInTheMiddle.monkey_business_10k() |> IO.inspect()
