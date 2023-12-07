Code.require_file("camel_cards.ex")
import ExUnit.Assertions

CamelCards.total_winnings("example.txt")
|> then(fn result -> assert(result == 6440) end)

CamelCards.total_winnings("input.txt")
|> IO.inspect(label: "Part 1")
|> then(fn result -> assert(result == 248_113_761) end)

CamelCards.total_winnings_with_joker("example.txt")
|> then(fn result -> assert(result == 5905) end)

CamelCards.total_winnings_with_joker("input.txt")
|> IO.inspect(label: "Part 2")
|> then(fn result -> assert(result == 246_285_222) end)
