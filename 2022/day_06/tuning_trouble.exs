defmodule TuningTrouble do
  def start_of_packet_marker(packet_size) do
    datastream_buffer = File.read!("input.txt")
    0..String.length(datastream_buffer)
    |> Enum.map(fn start -> String.slice(datastream_buffer, start, packet_size)
    |> String.split("", trim: true)
    |> Enum.uniq
    |> Enum.count() end)
    |> Enum.find_index(fn packet -> packet == packet_size end)
    |> then(&(&1 + packet_size))
  end
end

TuningTrouble.start_of_packet_marker(4) |> IO.inspect(label: "Part 1")
TuningTrouble.start_of_packet_marker(14) |> IO.inspect(label: "Part 2")
