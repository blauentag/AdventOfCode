defmodule ElfSnackCalories do

  def calorie_count_by_elf do
    File.read!("input.txt")
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn (snacks) -> String.split(snacks, "\n", trim: true) |> Enum.map(&String.to_integer/1) end)
    |> Enum.map(fn calorie -> Enum.sum(calorie) end)
  end

  def most_calories_carried_by_elf do
    calorie_count_by_elf()
      |> Enum.reduce(&max/2)
  end

  def calories_carried_by_top_3_elves do
    calorie_count_by_elf()
      |> Enum.sort
      |> Enum.take(-3)
      |> Enum.sum
  end
end

ElfSnackCalories.most_calories_carried_by_elf() |> IO.puts
ElfSnackCalories.calories_carried_by_top_3_elves() |> IO.puts
