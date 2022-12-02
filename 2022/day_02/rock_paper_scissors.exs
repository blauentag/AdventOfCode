defmodule RockPaperScissors do

  def scoring do
    %{
      "X" => 1,
      "Y" => 2,
      "Z" => 3,
      "loss" => 0,
      "tie" => 3,
      "win" => 6
    }
  end

  def counter_strategy do
    %{
      "A X" => scoring()["loss"] + scoring()["Z"],
      "B X" => scoring()["loss"] + scoring()["X"],
      "C X" => scoring()["loss"] + scoring()["Y"],
      "A Y" => scoring()["tie"] + scoring()["X"],
      "B Y" => scoring()["tie"] + scoring()["Y"],
      "C Y" => scoring()["tie"] + scoring()["Z"],
      "A Z" => scoring()["win"] + scoring()["Y"],
      "B Z" => scoring()["win"] + scoring()["Z"],
      "C Z" => scoring()["win"] + scoring()["X"],
    }
  end

  def head_to_head_strategy do
    %{
      "A X" => scoring()["X"] + scoring()["tie"],
      "B X" => scoring()["X"] + scoring()["loss"],
      "C X" => scoring()["X"] + scoring()["win"],
      "A Y" => scoring()["Y"] + scoring()["win"],
      "B Y" => scoring()["Y"] + scoring()["tie"],
      "C Y" => scoring()["Y"] + scoring()["loss"],
      "A Z" => scoring()["Z"] + scoring()["loss"],
      "B Z" => scoring()["Z"] + scoring()["win"],
      "C Z" => scoring()["Z"] + scoring()["tie"],
    }
  end

  def score(strategy) do
    File.stream!("input.txt")
    |> Enum.map(&String.trim/1)
    |> Enum.map(fn (round) -> strategy[round] end)
    |> Enum.sum()
  end
end

RockPaperScissors.score(RockPaperScissors.head_to_head_strategy()) |> IO.puts
RockPaperScissors.score(RockPaperScissors.counter_strategy()) |> IO.puts
