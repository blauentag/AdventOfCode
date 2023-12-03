Code.require_file("gear_ratios.ex")
import ExUnit.Assertions

GearRatios.sum_part_numbers("part_1_sample.txt")
|> then(fn result -> assert(result == 4361) end)

GearRatios.sum_part_numbers("part_1.txt")
|> IO.inspect(label: "Part 1")
|> then(fn result -> assert(result == 498_559) end)

GearRatios.sum_gear_ratios("part_2_sample.txt")
|> then(fn result -> assert(result == 467_835) end)

GearRatios.sum_gear_ratios("part_2.txt")
|> IO.inspect(label: "Part 2")
|> then(fn result -> assert(result == 72_246_648) end)
