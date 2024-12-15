#!/usr/bin/python3

import os
import re

from functools import reduce


def robot_vectors():
    with open(
        os.path.join(os.path.dirname(os.path.abspath(__file__)), "input.txt")
    ) as file:
        lines: list[str] = [line.rstrip() for line in file]

    foyer_map = (
        [
            (tuple(map(int, vector[0])), tuple(map(int, vector[1])))
            for vector in [re.findall(r"([-\d]+),([-\d]+)", line) for line in lines]
        ],
        101,
        103,
    )

    lines = [
        "p=0,4 v=3,-3",
        "p=6,3 v=-1,-3",
        "p=10,3 v=-1,2",
        "p=2,0 v=2,-1",
        "p=0,0 v=1,3",
        "p=3,0 v=-2,-2",
        "p=7,6 v=-1,-3",
        "p=3,0 v=-1,-2",
        "p=9,3 v=2,3",
        "p=7,3 v=-1,2",
        "p=2,4 v=2,-3",
        "p=9,5 v=-3,-3",
    ]

    # foyer_map = ([
    #     (tuple(map(int, vector[0])), tuple(map(int, vector[1])))
    #     for vector in [re.findall(r"([-\d]+),([-\d]+)", line) for line in lines]
    # ], 11, 7)

    return foyer_map


def robot_positions_after_seconds(vector, width, height, seconds=100):
    (column, row), (d_column, d_row) = vector
    column_modulo = abs(d_column * seconds) % width
    row_modulo = abs(d_row * seconds) % height

    if d_row < 0:
        row = row - row_modulo if row - row_modulo >= 0 else height + row - row_modulo
    else:
        row = (
            row + row_modulo if row + row_modulo < height else row - height + row_modulo
        )

    if d_column < 0:
        column = (
            column - column_modulo
            if column - column_modulo >= 0
            else width + column - column_modulo
        )
    else:
        column = (
            column + column_modulo
            if column + column_modulo < width
            else column - width + column_modulo
        )

    return column, row


def divide_into_quadrants(coordinates, width, height):
    quadrants = {
        "upper_left": [],
        "upper_right": [],
        "lower_left": [],
        "lower_right": [],
    }

    x_mid = int(width / 2)
    y_mid = int(height / 2)

    for x, y in coordinates:
        if x < x_mid and y < y_mid:
            quadrants["upper_left"].append((x, y))
        elif x > x_mid and y < y_mid:
            quadrants["upper_right"].append((x, y))
        elif x < x_mid and y > y_mid:
            quadrants["lower_left"].append((x, y))
        elif x > x_mid and y > y_mid:
            quadrants["lower_right"].append((x, y))

    return quadrants


def part_1(vectors, width, height, seconds):
    return reduce(
        lambda a, b: a * b,
        [
            len(positions)
            for positions in divide_into_quadrants(
                [
                    robot_positions_after_seconds(vector, width, height, seconds)
                    for vector in vectors
                ],
                width,
                height,
            ).values()
        ],
        1,
    )


def calculate_variance(sublist):
    mean = sum(sublist) / len(sublist)
    return sum((x - mean) ** 2 for x in sublist) / (len(sublist) - 1)


def part_2(vectors, width, height):
    y_variances = [
        (i, calculate_variance(lst))
        for i, lst in enumerate(
            [
                [
                    y
                    for (x, y) in [
                        robot_positions_after_seconds(vector, width, height, seconds)
                        for vector in vectors
                    ]
                ]
                for seconds in range(height)
            ]
        )
    ]
    x_variances = [
        (i, calculate_variance(lst))
        for i, lst in enumerate(
            [
                [
                    x
                    for (x, y) in [
                        robot_positions_after_seconds(vector, width, height, seconds)
                        for vector in vectors
                    ]
                ]
                for seconds in range(height)
            ]
        )
    ]
    least_variance_y = min(y_variances, key=lambda x: x[1])
    least_variance_x = min(x_variances, key=lambda x: x[1])

    seconds = width
    while True:
        seconds += 1
        if (
            calculate_variance(
                [
                    y
                    for (x, y) in [
                        robot_positions_after_seconds(vector, width, height, seconds)
                        for vector in vectors
                    ]
                ]
            )
            <= least_variance_y[1]
            and calculate_variance(
                [
                    x
                    for (x, y) in [
                        robot_positions_after_seconds(vector, width, height, seconds)
                        for vector in vectors
                    ]
                ]
            )
            <= least_variance_x[1]
        ):
            break

    return seconds


if __name__ == "__main__":
    print(f"Part 1: {part_1(*robot_vectors(), seconds=100)}")
    print(f"Part 2: {part_2(*robot_vectors())}")
