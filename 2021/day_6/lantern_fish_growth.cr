content = File.read("./input.txt")
fish_array = content.split(",")
fish_array = fish_array.map { |c| Int32.new(c) }

def pass_time(days_left : Int32) : Int32
    return 6 if days_left.zero?

    days_left - 1
end

life_cycles = 80
(1..life_cycles).each do |_|
    new_fish = fish_array.count(0)
    fish_array = fish_array.map { |fish| pass_time(fish) }
    fish_array += [8] * new_fish
end

puts fish_array.size()
# 358214