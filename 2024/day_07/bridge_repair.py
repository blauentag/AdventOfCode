#!/usr/bin/python3
import math
import os
from functools import reduce


def input_to_equations():
    with open(
        os.path.join(os.path.dirname(os.path.abspath(__file__)), "input.txt")
    ) as file:
        lines: list[str] = [line.rstrip() for line in file]

    # lines = [
    #     "190: 10 19",
    #     "3267: 81 40 27",
    #     "83: 17 5",
    #     "156: 15 6",
    #     "7290: 6 8 6 15",
    #     "161011: 16 10 13",
    #     "192: 17 8 14",
    #     "21037: 9 7 18 13",
    #     "292: 11 6 16 20",
    #     "1003001: 9 2 8 2 969 3 291 5 500",
    # ]

    return {
        int(calibrations[0][:-1]): [int(value) for value in calibrations[1:]]
        for calibrations in [line.split(" ") for line in lines]
    }


def dfs(key, values, index, current_result, use_concatenation):
    if index == len(values):
        return current_result

    add_result = dfs(
        key, values, index + 1, current_result + values[index], use_concatenation
    )
    if add_result == key:
        return add_result

    if index > 0:
        mul_result = dfs(
            key, values, index + 1, current_result * values[index], use_concatenation
        )
        if mul_result == key:
            return mul_result

    if use_concatenation:
        con_result = dfs(
            key,
            values,
            index + 1,
            int(str(current_result) + str(values[index])),
            use_concatenation,
        )
        if con_result == key:
            return con_result

    return None


def find_test_value(dictionary, use_concatenation=False):
    total_sum = 0
    for key, values in dictionary.items():
        result = dfs(key, values, 0, 0, use_concatenation)
        if result is not None:
            total_sum += result
    return total_sum


def part_1(equations):
    return find_test_value(equations)


def part_2(equations):
    return find_test_value(equations, True)


if __name__ == "__main__":
    print(f"Part 1: {part_1(input_to_equations())}")
    print(f"Part 2: {part_2(input_to_equations())}")
