defmodule CamelCards do
  def total_winnings(file_name) do
    setup(file_name)
    |> Enum.sort_by(fn hand -> score_hand(hand) end, :desc)
    |> Enum.reverse()
    |> Enum.with_index(1)
    |> Enum.map(fn {{_, bid}, index} -> bid * index end)
    |> Enum.sum()
  end

  def total_winnings_with_joker(file_name) do
    setup(file_name)
    |> Enum.sort_by(fn hand -> score_hand_with_joker(hand) end, :desc)
    |> Enum.reverse()
    |> Enum.with_index(1)
    |> Enum.map(fn {{_, bid}, index} -> bid * index end)
    |> Enum.sum()
  end

  def score_hand({hand, _}) do
    type_score(hand) + card_score(hand)
  end

  def score_hand_with_joker({hand, _}) do
    type_score_with_joker(hand) + card_score_with_joker(hand)
  end

  def type_score(hand) do
    Enum.frequencies(hand)
    |> hand_type
    |> score_type
  end

  def card_score(hand) do
    Enum.reverse(hand)
    |> Enum.with_index()
    |> Enum.map(fn {card, index} -> score_card(card, index) end)
    |> Enum.sum()
  end

  def type_score_with_joker(hand) do
    Enum.frequencies(hand)
    |> hand_type_with_joker
    |> score_type
  end

  def card_score_with_joker(hand) do
    Enum.reverse(hand)
    |> Enum.with_index()
    |> Enum.map(fn {card, index} -> score_card_with_joker(card, index) end)
    |> Enum.sum()
  end

  def hand_type(frequencies) do
    distinct_cards = Map.keys(frequencies) |> length
    card_counts = Map.values(frequencies) |> Enum.sort()

    case {distinct_cards, card_counts} do
      {1, _} -> "five_of_a_kind"
      {2, x} when x == [1, 4] -> "four_of_a_kind"
      {2, x} when x == [2, 3] -> "full_house"
      {3, x} when x == [1, 1, 3] -> "three_of_a_kind"
      {3, x} when x == [1, 2, 2] -> "two_pair"
      {4, _} -> "one_pair"
      {5, _} -> "high_card"
    end
  end

  def hand_type_with_joker(frequencies) do
    {joker_count, card_frequencies} = Map.pop(frequencies, "J")

    distinct_cards = Map.keys(card_frequencies) |> length

    card_counts =
      if is_nil(joker_count) do
        Map.values(card_frequencies) |> Enum.sort()
      else
        values = Map.values(card_frequencies)

        unless Enum.empty?(values) do
          max = Enum.max(values)
          index_first_max = Enum.find_index(values, fn value -> value == max end)

          Enum.with_index(values)
          |> Enum.map(fn {value, index} ->
            if index == index_first_max, do: value + joker_count, else: value
          end)
        else
          []
        end
        |> Enum.sort()
      end

    case {distinct_cards, card_counts} do
      {0, _} -> "five_of_a_kind"
      {1, _} -> "five_of_a_kind"
      {2, x} when x == [1, 4] -> "four_of_a_kind"
      {2, x} when x == [2, 3] -> "full_house"
      {3, x} when x == [1, 1, 3] -> "three_of_a_kind"
      {3, x} when x == [1, 2, 2] -> "two_pair"
      {4, _} -> "one_pair"
      {5, _} -> "high_card"
    end
  end

  def score_card(card, index) do
    Map.get(
      %{
        "A" => 14,
        "K" => 13,
        "Q" => 12,
        "J" => 11,
        "T" => 10,
        "9" => 9,
        "8" => 8,
        "7" => 7,
        "6" => 6,
        "5" => 5,
        "4" => 4,
        "3" => 3,
        "2" => 2
      },
      card
    ) * Integer.pow(14, index)
  end

  def score_card_with_joker(card, index) do
    Map.get(
      %{
        "A" => 14,
        "K" => 13,
        "Q" => 12,
        "T" => 10,
        "9" => 9,
        "8" => 8,
        "7" => 7,
        "6" => 6,
        "5" => 5,
        "4" => 4,
        "3" => 3,
        "2" => 2,
        "J" => 1
      },
      card
    ) * Integer.pow(14, index)
  end

  def score_type(hand) do
    Map.get(
      %{
        "five_of_a_kind" => 70_000_000,
        "four_of_a_kind" => 60_000_000,
        "full_house" => 50_000_000,
        "three_of_a_kind" => 40_000_000,
        "two_pair" => 30_000_000,
        "one_pair" => 20_000_000,
        "high_card" => 10_000_000
      },
      hand
    )
  end

  def setup(file_name) do
    File.read!(file_name)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> String.split(line, " ", trim: true) |> List.to_tuple() end)
    |> Enum.map(fn {hand, bid} ->
      {String.split(hand, "", trim: true), bid |> Integer.parse() |> elem(0)}
    end)
  end
end
