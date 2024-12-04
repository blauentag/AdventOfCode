#!/usr/bin/python3

import os

with open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "input.txt")) as file:
    lines = [line.rstrip() for line in file]

# lines = [
# "MMMSXXMASM",
# "MSAMXMSMSA",
# "AMXSXMAAMM",
# "MSAMASMSMX",
# "XMASAMXAMM",
# "XXAMMXXAMA",
# "SMSMSASXSS",
# "SAXAMASAAA",
# "MAMMMXMMMM",
# "MXMXAXMASX",
# ]

XMAS = "XMAS"
SAMX = "SAMX"


def holds_xmas(char_list):
    line = "".join(char_list)

    return line.count(XMAS) + line.count(SAMX)


def get_columns(list_of_lists):
    row_count = len(list_of_lists)
    column_count = len(list_of_lists[0])

    columns = []
    for col in range(column_count):
        column = [list_of_lists[row][col] for row in range(row_count)]
        columns.append(column)

    return columns


def get_diagonals_left_to_right(list_of_lists):
    diagonals = []
    row_count = len(list_of_lists)
    column_count = len(list_of_lists[0])

    for column_index in range(column_count):
        diagonal = []
        for row_index in range(min(row_count, column_count - column_index)):
            diagonal.append(list_of_lists[row_index][column_index + row_index])
        if len(diagonal) >= 4:
            diagonals.append(diagonal)

    for column_index in range(1, row_count):
        diagonal = []
        for row_index in range(min(row_count - column_index, column_count)):
            diagonal.append(list_of_lists[column_index + row_index][row_index])
        if len(diagonal) >= 4:
            diagonals.append(diagonal)

    return diagonals


def get_diagonals_right_to_left(list_of_lists):
    diagonals = []
    row_count = len(list_of_lists)
    column_count = len(list_of_lists[0])

    for index in range(column_count):
        diagonal = []
        row = 0
        column = index
        while row < row_count and column >= 0:
            diagonal.append(list_of_lists[row][column])
            row += 1
            column -= 1
        if len(diagonal) >= 4:
            diagonals.append(diagonal)

    for index in range(1, row_count):
        diagonal = []
        row = index
        column = column_count - 1
        while row < row_count and column >= 0:
            diagonal.append(list_of_lists[row][column])
            row += 1
            column -= 1
        if len(diagonal) >= 4:
            diagonals.append(diagonal)

    return diagonals


def is_x_mas(lines, row_index, column_index):
    x_mas = ["MAS", "SAM"]
    ltr = lines[row_index - 1][column_index - 1] + \
          lines[row_index][column_index] + \
          lines[row_index + 1][column_index + 1]
    rtl = lines[row_index + 1][column_index - 1] + \
          lines[row_index][column_index] + \
          lines[row_index - 1][column_index + 1]

    return ltr in x_mas and rtl in x_mas


xmas_count = 0
lines = [list(line) for line in lines]
for line in lines:
    xmas_count += holds_xmas(line)

for line in get_columns(lines):
    xmas_count += holds_xmas(line)

for line in get_diagonals_left_to_right(lines):
    xmas_count += holds_xmas(line)

for line in get_diagonals_right_to_left(lines):
    xmas_count += holds_xmas(line)

print(f"Part 1: {xmas_count}")

x_mas_count = 0
row_count = len(lines)
column_count = len(lines[0])
for row_index, line in enumerate(lines):
    if row_index in (0, row_count - 1):
        continue
    for column_index, char in enumerate(line):
        if column_index in (0, column_count - 1):
            continue
        if char != "A":
            continue
        if is_x_mas(lines, row_index, column_index):
            x_mas_count += 1

print(f"Part 2: {x_mas_count}")