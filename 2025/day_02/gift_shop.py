#!/usr/bin/python3

import sys


def main(filename):
    with open(filename, "r") as file:
        ranges = [
            list(map(int, line.split("-"))) for line in file.readline().split(",")
        ]

    invalid_ids = [
        id for ids in ranges for id in range(ids[0], ids[-1] + 1) if is_repeated(id)
    ]
    repetitive_ids = [
        id
        for ids in ranges
        for id in range(ids[0], ids[-1] + 1)
        if is_repetetive_sequences(id)
    ]

    return sum(invalid_ids), sum(repetitive_ids)


def is_repeated(id):
    id_as_string = str(id)
    length = len(id_as_string)
    if length % 2 != 0:
        return False
    midpoint = length // 2
    return id_as_string[:midpoint] == id_as_string[midpoint:]


def is_repetetive_sequences(id):
    id_as_string = str(id)
    doubled_id = id_as_string + id_as_string
    return id_as_string in doubled_id[1:-1]


if __name__ == "__main__":
    part_1, part_2 = main(sys.argv[1])
    print(f"Part 1:\t{part_1}")
    print(f"Part 2:\t{part_2}")
