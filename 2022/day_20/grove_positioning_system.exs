defmodule Origin do
  @enforce_keys [:vector, :location]
  defstruct [:vector, :location]
end

defmodule GrovePositioningSystem do
  @decryption_key 811_589_153

  def numbers(file_name) do
    File.read!(file_name)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer(&1))
    |> Enum.with_index()
    |> Enum.map(fn {vector, location} -> %Origin{vector: vector, location: location} end)
  end

  def mix(ordered_numbers, passed_positions) do
    positions =
      if is_map(passed_positions) do
        passed_positions
      else
        Enum.reduce(ordered_numbers, %{}, fn origin, positions ->
          Map.put(positions, origin, origin.location)
        end)
      end

    length = Enum.count(positions)

    Enum.reduce(ordered_numbers, positions, fn number_key, mix ->
      Enum.reduce(mix, mix, fn {num_key, ind}, new_mix ->
        number = number_key.vector
        index = Map.fetch!(mix, number_key)
        number_moves_to = Integer.mod(index + number, length - 1)

        cond do
          num_key == number_key ->
            Map.replace!(new_mix, num_key, number_moves_to)

          index < number_moves_to and Enum.member?((index + 1)..number_moves_to, ind) ->
            Map.replace!(new_mix, num_key, Integer.mod(ind - 1, length - 1))

          index > number_moves_to and Enum.member?(number_moves_to..(index - 1), ind) ->
            new_pos =
              if Integer.mod(ind + 1, length - 1) == 0,
                do: length - 1,
                else: Integer.mod(ind + 1, length - 1)

            Map.replace!(new_mix, num_key, new_pos)

          true ->
            new_mix
        end
      end)
    end)
  end

  def sum(mix) do
    length = Enum.count(mix)
    zero_key = Map.keys(mix) |> Enum.find(fn origin -> origin.vector == 0 end)
    zero_index = Map.fetch!(mix, zero_key)

    reverse_mix =
      Enum.reduce(mix, %{}, fn {origin, position}, reversed ->
        Map.put(reversed, position, origin.vector)
      end)

    Enum.map([1000, 2000, 3000], fn num ->
      Map.fetch!(reverse_mix, Integer.mod(zero_index + num, length))
    end)
    |> Enum.sum()
  end

  def sum_numbers_for_grove_coordinates(filename) do
    numbers(filename)
    |> mix(nil)
    |> sum()
  end

  def sum_numbers_with_10x_decryption_key(filename) do
    numbers_with_decryption_key =
      numbers(filename)
      |> Enum.map(fn origin ->
        %Origin{vector: origin.vector * @decryption_key, location: origin.location}
      end)

    positions_with_decryption_key =
      Enum.reduce(numbers_with_decryption_key, %{}, fn origin, positions ->
        Map.put(positions, origin, origin.location)
      end)

    Enum.reduce(1..10, positions_with_decryption_key, fn _, positions ->
      mix(numbers_with_decryption_key, positions)
    end)
    |> sum()
  end
end

GrovePositioningSystem.sum_numbers_for_grove_coordinates("input.txt")
|> IO.inspect(label: :part_1)  # ~25 seconds

GrovePositioningSystem.sum_numbers_with_10x_decryption_key("input.txt")
|> IO.inspect(label: :part_2)  # ~4 minutes
