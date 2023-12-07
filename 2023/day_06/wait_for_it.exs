Code.require_file("wait_for_it.ex")
import ExUnit.Assertions

WaitForIt.ways_to_win("example.txt", 1)
|> then(fn result -> assert(result == 288) end)

WaitForIt.ways_to_win("input.txt", 1)
|> IO.inspect(label: "Part 1")
|> then(fn result -> assert(result == 281_600) end)

WaitForIt.ways_to_win("example.txt", 2)
|> then(fn result -> assert(result == 71_503) end)

WaitForIt.ways_to_win("input.txt", 2)
|> IO.inspect(label: "Part 2")
|> then(fn result -> assert(result == 33_875_953) end)
