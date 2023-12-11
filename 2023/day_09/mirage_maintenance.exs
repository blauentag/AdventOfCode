Code.require_file("mirage_maintenance.ex")
import ExUnit.Assertions

MirageMaintenance.sum_extrapolated_values("example.txt", true)
|> then(fn result -> assert(result == 114) end)

MirageMaintenance.sum_extrapolated_values("input.txt", true)
|> IO.inspect(label: "Part 1")
|> then(fn result -> assert(result == 1_708_206_096) end)

MirageMaintenance.sum_extrapolated_values("example.txt", false)
|> then(fn result -> assert(result == 2) end)

MirageMaintenance.sum_extrapolated_values("input.txt", false)
|> IO.inspect(label: "Part 2")
|> then(fn result -> assert(result > 228) end)
