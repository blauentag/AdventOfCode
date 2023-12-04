Code.require_file("scratchcards.ex")
import ExUnit.Assertions

Scratchcards.total_points("example.txt")
|> then(fn result -> assert(result == 13) end)

Scratchcards.total_points("input.txt")
|> IO.inspect(label: "Part 1")
|> then(fn result -> assert(result == 23_028) end)

Scratchcards.total_scratch_cards("example.txt")
|> then(fn result -> assert(result == 30) end)

Scratchcards.total_scratch_cards("input.txt")
|> IO.inspect(label: "Part 2")
|> then(fn result -> assert(result == 9_236_992) end)
