#!/usr/bin/env ruby

fs = File.read './input.txt'

HEIGHT_MAP = fs.split("\n").map  do |line|
    line.split('')
    .map(&:to_i)
end

MAX_HEIGHT = HEIGHT_MAP.size
MAX_WIDTH = HEIGHT_MAP.first.size

def moves(row, column)
  moves = []
  moves.append([row + 1, column]) if valid_move?(row + 1, column)
  moves.append([row - 1, column]) if valid_move?(row - 1, column)
  moves.append([row, column + 1]) if valid_move?(row, column + 1)
  moves.append([row, column - 1]) if valid_move?(row, column - 1)
  moves
end

def valid_move?(row, column)
  (0...MAX_HEIGHT).include?(row) && (0...MAX_WIDTH).include?(column)
end

def depth(coord)
  HEIGHT_MAP[coord.first][coord.last]
end

searched = []
basins = []
for row in 0...MAX_HEIGHT
  for column in 0...MAX_WIDTH
    point = [row, column]
    next if searched.include?(point)

    searched.append(point)
    next if depth(point) == 9
    
    search_list = []
    basin = [point]
    search_list.concat(moves(*point))

    while search_list.size > 0
      next_point = search_list.pop
      next if searched.include?(next_point)

      searched.append(next_point)
      next if depth(next_point) == 9

      basin.append(next_point)
      search_list.concat(moves(*next_point))
    end

    basins.append(basin.size)
  end
end

# 1056330
puts basins.sort.reverse.first(3).inject(:*)
