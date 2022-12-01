#!/usr/bin/env ruby

class OctopusFlashInterpreter

  def initialize(octopus_map)
    @octopus_map = octopus_map
    @flashes = 0
  end

  attr_reader :octopus_map

  def step(number)
    flashed = []
    all_increment
    for row in 0...max_height
      for col in 0...max_width
        stack = []
        point = [row, col]
        next if flashed.include?(point)

        if flash?(*point)
          flashed.append(point)
          flash
          adjacent_octopuses = moves(*point)
          adjacent_octopuses.each { |octopus| add_one(*octopus) }
          stack.concat(adjacent_octopuses)

          while stack.size > 0
            point = stack.pop
            next if flashed.include?(point)

            if flash?(*point)
              flashed.append(point)
              flash
              adjacent_octopuses = moves(*point)
              adjacent_octopuses.each { |octopus| add_one(*octopus) }
              stack.concat(adjacent_octopuses)
            end
          end
        end
      end
    end
    puts("#{number}") if synchronous_flash?
    reset
  end

  def flash_count
    flashes
  end

  def synchronous_flash?
    octopus_map.map { |row| row.select { |val| val > 9 } }
    .map { |row| row.count }
    .sum == 100
  end

  private

  attr_accessor :flashes

  def all_increment
    octopus_map.each_with_index do |line,row|
      line.each_with_index { |_,col| octopus_map[row][col] += 1 }
    end
  end

  def add_one(row, col)
    octopus_map[row][col] += 1
  end

  def flash
    @flashes += 1
  end

  def flash?(row, col)
    octopus_map[row][col] > 9
  end

  def max_height
    octopus_map.size
  end

  def max_width
    octopus_map.first.size
  end

  def moves(row, col)
    moves = []
    moves.append([row + 1, col - 1]) if valid_move?(row + 1, col - 1)
    moves.append([row + 1, col]) if valid_move?(row + 1, col)
    moves.append([row + 1, col + 1]) if valid_move?(row + 1, col + 1)
    moves.append([row, col - 1]) if valid_move?(row, col - 1)
    moves.append([row, col + 1]) if valid_move?(row, col + 1)
    moves.append([row - 1, col - 1]) if valid_move?(row - 1, col - 1)
    moves.append([row - 1, col]) if valid_move?(row - 1, col)
    moves.append([row - 1, col + 1]) if valid_move?(row - 1, col + 1)
    moves
  end

  def print
    octopus_map.each do |row|
      puts row.join("")
    end
  end

  def reset
    octopus_map.each_with_index do |line,row|
      line.each_with_index { |val,col| octopus_map[row][col] = 0 if val > 9 }
    end
  end

  def valid_move?(row, col)
    (0...max_height).include?(row) && (0...max_width).include?(col)
  end

end

octopus_map = File.read('./input.txt').split("\n").map  do |line|
  line.split('')
  .map(&:to_i)
end

# octopus_map = """5483143223
# 2745854711
# 5264556173
# 6141336146
# 6357385478
# 4167524645
# 2176841721
# 6882881134
# 4846848554
# 5283751526""".split("\n").map { |line| line.split('').map(&:to_i) }


interpreter = OctopusFlashInterpreter.new(octopus_map)
for step in 1..1000
  interpreter.step(step)
end



