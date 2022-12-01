content = File.read("./input.txt")
fish_array = content.split(",")
fish_array = fish_array.map { |c| Int32.new(c) }

def pass_time(fish : Hash(Int32, Int64)) : Hash(Int32, Int64)
    {
        0 => Int64.new(fish.fetch(1, 0)),
        1 => Int64.new(fish.fetch(2, 0)),
        2 => Int64.new(fish.fetch(3, 0)),
        3 => Int64.new(fish.fetch(4, 0)),
        4 => Int64.new(fish.fetch(5, 0)),
        5 => Int64.new(fish.fetch(6, 0)),
        6 => Int64.new(fish.fetch(7, 0) + fish.fetch(0, 0)),
        7 => Int64.new(fish.fetch(8, 0)),
        8 => Int64.new(fish.fetch(0, 0)),
    }
end

fish_counts = {
    0 => Int64.new(fish_array.count(0)),
    1 => Int64.new(fish_array.count(1)),
    2 => Int64.new(fish_array.count(2)),
    3 => Int64.new(fish_array.count(3)),
    4 => Int64.new(fish_array.count(4)),
    5 => Int64.new(fish_array.count(5)),
    6 => Int64.new(fish_array.count(6)),
    7 => Int64.new(fish_array.count(7)),
    8 => Int64.new(fish_array.count(8)),
}

life_cycles = 256
(1..life_cycles).each { fish_counts = pass_time(fish_counts) }

puts fish_counts.values().sum()
# 1622533344325