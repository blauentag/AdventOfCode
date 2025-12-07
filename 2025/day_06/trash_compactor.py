#!/usr/bin/python3

import sys
from functools import reduce
from operator import add, mul

operations = {
    "+": add,
    "*": mul,
}


def parse_input(filename):
    with open(filename, "r") as file:
        lines = [line.replace("\n", "") for line in file]

    return lines


def sum_vertical_operations(lines):
    operations_list = lines[-1].split()
    numbers = [[int(x) for x in line.split()] for line in lines[:-1]]
    transposed = [list(row) for row in zip(*numbers)]
    return sum(
        [
            reduce(operations[op], column)
            for column, op in zip(transposed, operations_list)
        ]
    )


def pad(string, length):
    return string.ljust(length, " ")


def sum_vertical_operations_right_to_left(lines):
    operations_list = list(filter(lambda item: item != " ", list(lines[-1])))
    column_indexes = [
        index - 1
        for index, char in enumerate(list(lines[-1]))
        if " " != char and 0 != index
    ]
    rtl_numbers = [
        transform_matrix(line)
        for line in [
            [chars for chars in row]
            for row in zip(
                *[
                    [list(num_str) for num_str in row]
                    for row in [
                        split_on_chars(line, positions=column_indexes)
                        for line in lines[:-1]
                    ]
                ]
            )
        ]
    ]

    return sum(
        [
            reduce(operations[op], column)
            for column, op in zip(rtl_numbers, operations_list)
        ]
    )


def split_on_chars(string, positions):
    result = []
    current_segment = ""

    for i, char in enumerate(string):
        if i in positions:
            if current_segment:
                result.append(current_segment)
                current_segment = ""
        else:
            current_segment += char

    if current_segment:
        result.append(current_segment)

    return result


def transform_matrix(matrix):
    rows = len(matrix)
    cols = len(matrix[0])

    result = []

    for col_idx in range(cols - 1, -1, -1):
        new_row = []
        for row_idx in range(rows):
            new_row.append(matrix[row_idx][col_idx])
        result.append(int("".join(new_row)))

    return result


def main(filename):
    lines = parse_input(filename)
    return sum_vertical_operations(lines), sum_vertical_operations_right_to_left(lines)


if __name__ == "__main__":
    part_1, part_2 = main(sys.argv[1])
    print(f"Part 1:\t{part_1}")
    print(f"Part 2:\t{part_2}")
