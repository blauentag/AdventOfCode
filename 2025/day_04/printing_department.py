#!/usr/bin/python3

import sys
from itertools import product
from functools import reduce


def main(filename):
    with open(filename, "r") as file:
        diagram = [[b for b in line.strip()] for line in file]

    return count_accessible_rolls(diagram), count_total_removable_rolls(diagram)


def count_accessible_rolls(diagram):
    return sum(
        diagram[x][y] == "@" and count_adjacent_positions(diagram, x, y) < 4
        for x, y in product(range(len(diagram)), range(len(diagram[0])))
    )


def is_valid_position(diagram, x, y):
    return 0 <= x < len(diagram) and 0 <= y < len(diagram[0])


def count_adjacent_positions(diagram, x, y):
    adjacent_positions = [
        (x + dx, y + dy)
        for dx, dy in [
            (-1, -1),
            (-1, 0),
            (-1, 1),
            (0, -1),
            (0, 1),
            (1, -1),
            (1, 0),
            (1, 1),
        ]
    ]
    valid_positions = [
        pos for pos in adjacent_positions if is_valid_position(diagram, pos[0], pos[1])
    ]
    return sum(diagram[pos[0]][pos[1]] == "@" for pos in valid_positions)


def count_total_removable_rolls(diagram):
    final_state = reduce(lambda acc, _: process_diagram(acc), range(1000), (diagram, 0))
    return final_state[1]


def get_accessible_rolls(current_diagram):
    return [
        (x, y)
        for x, y in product(range(len(current_diagram)), range(len(current_diagram[0])))
        if current_diagram[x][y] == "@"
        and count_adjacent_positions(current_diagram, x, y) < 4
    ]


def remove_rolls(current_diagram, rolls_to_remove):
    new_diagram = [row[:] for row in current_diagram]
    for x, y in rolls_to_remove:
        new_diagram[x][y] = "."
    return new_diagram


def process_diagram(diagram_and_removed_count):
    current_diagram, total_removed = diagram_and_removed_count
    accessible_rolls = get_accessible_rolls(current_diagram)
    if not accessible_rolls:
        return diagram_and_removed_count
    new_diagram = remove_rolls(current_diagram, accessible_rolls)
    return (new_diagram, total_removed + len(accessible_rolls))


if __name__ == "__main__":
    part_1, part_2 = main(sys.argv[1])
    print(f"Part 1:\t{part_1}")
    print(f"Part 2:\t{part_2}")
