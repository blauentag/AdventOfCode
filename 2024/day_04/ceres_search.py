#!/usr/bin/python3

import os


def lines():
    with open(
        os.path.join(os.path.dirname(os.path.abspath(__file__)), "input.txt")
    ) as file:
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

    return [list(line) for line in lines]


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
    ltr = (
        lines[row_index - 1][column_index - 1]
        + lines[row_index][column_index]
        + lines[row_index + 1][column_index + 1]
    )
    rtl = (
        lines[row_index + 1][column_index - 1]
        + lines[row_index][column_index]
        + lines[row_index - 1][column_index + 1]
    )

    return ltr in x_mas and rtl in x_mas


def part_1(lines):
    return (
        sum([holds_xmas(line) for line in lines])
        + sum([holds_xmas(line) for line in get_columns(lines)])
        + sum([holds_xmas(line) for line in get_diagonals_left_to_right(lines)])
        + sum([holds_xmas(line) for line in get_diagonals_right_to_left(lines)])
    )


def is_x(char, lines, row_index, column_index, column_count):
    if column_index in (0, column_count - 1):
        return 0

    if char != "A":
        return 0

    if is_x_mas(lines, row_index, column_index):
        return 1

    return 0


def find_x(line, lines, row_index, row_count, column_count):
    if row_index in (0, row_count - 1):
        return 0

    return sum(
        [
            is_x(char, lines, row_index, column_index, column_count)
            for column_index, char in enumerate(line)
        ]
    )


def part_2(lines):
    row_count = len(lines)
    column_count = len(lines[0])

    return sum(
        [
            find_x(line, lines, row_index, row_count, column_count)
            for row_index, line in enumerate(lines)
        ]
    )


print(f"Part 1: {part_1(lines())}")

print(f"Part 2: {part_2(lines())}")
