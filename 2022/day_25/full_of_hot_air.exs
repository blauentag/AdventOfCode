defmodule FullOfHotAir do
  @five 5

  def read_input(filename) do
    initial_state =
      File.read!(filename)
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))
      |> Enum.map(&Enum.reverse(&1))

    max_digits = Enum.max(Enum.map(initial_state, &length(&1))) - 1

    Enum.map(initial_state, fn line ->
      line ++ for(_ <- 0..(length(line) - max_digits), do: "0")
    end)
    |> Enum.zip_with(& &1)
  end

  def find_power(decimal, power, too_small) when too_small == true do
    if decimal > Integer.pow(@five, power),
      do: find_power(decimal, power + 1, true),
      else: find_power(decimal, power - 1, false)
  end

  def find_power(_, power, too_small) when too_small == false do
    power
  end

  def decimal_to_snafu(decimal) do
    find_power(decimal, 0, true)..0
    |> Enum.reduce({decimal, []}, fn pow, {number, snafu_list} ->
      five_to_n = Integer.pow(@five, pow)
      quotient_floor = floor(number / five_to_n)
      quotient_remainder = Integer.mod(number, five_to_n)
      {quotient_remainder, List.insert_at(snafu_list, 0, quotient_floor)}
    end)
    |> elem(1)
    |> Enum.with_index()
    |> Enum.reduce([], fn {decimal, index}, snafu_list ->
      decimal = decimal + Enum.at(snafu_list, index, 0)

      if decimal < 3 do
        if !!Enum.at(snafu_list, index),
          do: List.replace_at(snafu_list, index, Integer.to_string(decimal)),
          else: List.insert_at(snafu_list, index, Integer.to_string(decimal))
      else
        snafu =
          cond do
            decimal == 3 -> "="
            decimal == 4 -> "-"
          end

        snafu_list =
          if !!Enum.at(snafu_list, index),
            do: List.replace_at(snafu_list, index, snafu),
            else: List.insert_at(snafu_list, index, snafu)

        List.insert_at(snafu_list, index + 1, 1)
      end
    end)
    |> Enum.reverse()
    |> List.to_string()
  end

  def snafu_number(filename) do
    read_input(filename)
    |> Enum.with_index()
    |> Enum.reduce(0, fn {line, index}, sums ->
      Enum.reduce(line, 0, fn snafu, current ->
        cond do
          snafu == "=" -> -(2 * Integer.pow(@five, index))
          snafu == "-" -> -(1 * Integer.pow(@five, index))
          is_nil(snafu) -> 0
          snafu == "0" -> 0
          snafu == "1" -> 1 * Integer.pow(@five, index)
          snafu == "2" -> 2 * Integer.pow(@five, index)
        end + current
      end) + sums
    end)
    |> decimal_to_snafu()
  end
end

System.argv()
|> then(&if &1 == [], do: IO.read(:all), else: List.first(&1))
|> String.trim()
|> FullOfHotAir.snafu_number()
|> IO.inspect(label: :snafu)
