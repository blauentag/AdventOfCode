defmodule TrebuchetCalibration do
  def sum_calibration_values(file_name, value_type) do
    setup(file_name)
    |> calibrate(value_type)
    |> parse_and_sum
  end

  def setup(file_name) do
    file_name
    |> File.read!()
    |> String.split("\n")
  end

  def calibrate(lines, value_type) do
    case value_type do
      :numeric -> calibrate_numeric_values(lines)
      :word -> calibrate_word_values(lines)
    end
  end

  def parse_and_sum(list) do
    list
    |> Enum.map(fn value ->
      case Integer.parse(value) do
        {num, ""} -> num
        _ -> 0
      end
    end)
    |> Enum.sum()
  end

  def calibrate_numeric_values(lines) do
    Enum.map(lines, fn line -> String.split(line, "") end)
    |> Enum.map(fn line ->
      Enum.filter(line, fn char -> Regex.match?(~r/^\d+$/, char) end)
    end)
    |> Enum.map(fn line ->
      "#{List.first(line)}#{List.last(line)}"
    end)
  end

  def calibrate_word_values(lines) do
    Enum.map(lines, fn line ->
      first = line |> get_numeric(:first)
      last = line |> String.reverse() |> get_numeric(:last)
      "#{first}#{last}"
    end)
  end

  def get_numeric(line, position) do
    regex =
      case position do
        :first -> ~r/one|two|three|four|five|six|seven|eight|nine/
        :last -> ~r/eno|owt|eerht|ruof|evif|xis|neves|thgie|enin/
      end

    value_map =
      case position do
        :first -> numeric_map()
        :last -> reversed_numeric_map()
      end

    Regex.replace(
      regex,
      line,
      fn match -> Map.get(value_map, match, match) end
    )
    |> String.split("", trim: true)
    |> Enum.filter(fn char -> Regex.match?(~r/^\d+$/, char) end)
    |> List.first("")
  end

  def numeric_map do
    %{
      "one" => "1",
      "two" => "2",
      "three" => "3",
      "four" => "4",
      "five" => "5",
      "six" => "6",
      "seven" => "7",
      "eight" => "8",
      "nine" => "9"
    }
  end

  def reversed_numeric_map do
    %{
      "eno" => "1",
      "owt" => "2",
      "eerht" => "3",
      "ruof" => "4",
      "evif" => "5",
      "xis" => "6",
      "neves" => "7",
      "thgie" => "8",
      "enin" => "9"
    }
  end
end
