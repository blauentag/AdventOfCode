Code.require_file("cube_conundrum.ex")
import ExUnit.Assertions

CubeConundrum.sum_game_ids("part_1_sample.txt") |> then(fn result -> assert(result == 8) end)
CubeConundrum.sum_game_ids("part_1.txt") |> IO.inspect(label: "Part 1")

CubeConundrum.sum_of_power_of_fewest_cubes("part_2_sample.txt")
|> then(fn result -> assert(result == 2286) end)

CubeConundrum.sum_of_power_of_fewest_cubes("part_2.txt") |> IO.inspect(label: "Part 2")
