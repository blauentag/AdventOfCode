Code.require_file("trebuchet_calibration.ex")
import ExUnit.Assertions

TrebuchetCalibration.sum_calibration_values("part_1_sample.txt", :numeric) |> then(fn result -> assert(result == 142) end)
TrebuchetCalibration.sum_calibration_values("part_1.txt", :numeric) |> IO.inspect(label: "Part 1")

TrebuchetCalibration.sum_calibration_values("part_2_sample.txt", :word) |> then(fn result -> assert(result == 281) end)
TrebuchetCalibration.sum_calibration_values("part_2.txt", :word) |> IO.inspect(label: "Part 2")
