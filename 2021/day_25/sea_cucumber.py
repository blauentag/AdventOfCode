#!/usr/bin/env python

with open("./input.txt", "r") as fs:
    lines = fs.read().split("\n")


seafloor = [list(line) for line in lines]
row_count = len(seafloor)
col_count = len(seafloor[0])
east = ">"
south = "v"
empty = "."


def step(seafloor_start):
    moves = 0
    seafloor_end = []
    for row_index in range(0, row_count):
        row = []
        for col_index in range(0, col_count):
            if (
                seafloor_start[row_index][col_index - 1] == east
                and seafloor_start[row_index][col_index] == empty
            ):
                if row:
                    row[-1] = empty
                row.append(">")
                moves += 1
            else:
                row.append(seafloor_start[row_index][col_index])

        if row[0] == east and seafloor_start[row_index][0] == empty:
            row[-1] = empty

        for col_index in range(0, col_count):
            if (
                seafloor_start[row_index - 1][col_index] == south
                and row[col_index] == empty
            ):
                if seafloor_end and seafloor_end[row_index - 1]:
                    seafloor_end[row_index - 1][col_index] = empty
                row[col_index] = south
                moves += 1

        seafloor_end.append(row)

    if row_index == row_count - 1:
        for col_index in range(0, col_count):
            if (
                seafloor_end[0][col_index] == south
                and seafloor_start[0][col_index] != south
            ):
                seafloor_end[-1][col_index] = empty

    return (moves, seafloor_end)


moves = 1
step_count = 0
while moves:
    moves, seafloor = step(seafloor)
    step_count += 1

print(step_count)
