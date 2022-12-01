#!/usr/bin/env ruby

fs = File.read './input.txt'

HEIGHT_MAP = fs.split("\n").map  do |line|
    line.split('')
    .map(&:to_i)
end

MAX_HEIGHT = HEIGHT_MAP.size
MAX_WIDTH = HEIGHT_MAP.first.size

def low_point?(row, column)
  point = HEIGHT_MAP[row][column]
  if row + 1 < MAX_HEIGHT  # right
    if HEIGHT_MAP[row + 1][column] <= point
      return false
    end
  end

  if row - 1 >= 0  # left
    if HEIGHT_MAP[row - 1][column] <= point
      return false
    end
  end

  if column + 1 < MAX_WIDTH  # below
    if HEIGHT_MAP[row][column + 1] <= point
      return false
    end
  end

  if column - 1 >= 0  # above
    if HEIGHT_MAP[row][column - 1] <= point
      return false
    end
  end

  true
end

low_points = []

for row in 0...MAX_HEIGHT
  for column in 0...MAX_WIDTH
    if low_point?(row, column)
      low_points.append(HEIGHT_MAP[row][column])
    end
  end
end

# 489
puts low_points.sum + low_points.size
