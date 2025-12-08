#!/usr/bin/python3

import sys


SPLITTER = "^"


def find_start_column(line):
    return [i for i, c in enumerate(line) if "S" == c][0]


def process_row(row, current_beams):
    split_count, new_beams = 0, {}

    for column_index, count in current_beams.items():
        if SPLITTER == row[column_index]:
            split_count += 1
            new_beams[column_index - 1] = new_beams.get(column_index - 1, 0) + count
            new_beams[column_index + 1] = new_beams.get(column_index + 1, 0) + count
        else:
            new_beams[column_index] = new_beams.get(column_index, 0) + count

    return new_beams, split_count


def tachyon_manifold(manifold):
    tachyon_beams, total_splits = {find_start_column(manifold[0]): 1}, 0

    for row in manifold[1:]:
        new_beams, splits = process_row(row, tachyon_beams)
        tachyon_beams = new_beams
        total_splits += splits

    return total_splits, sum(tachyon_beams.values())


def main(filename):
    with open(filename, "r") as file:
        return tachyon_manifold(file.readlines())


if __name__ == "__main__":
    part_1, part_2 = main(sys.argv[1])
    print(f"Part 1:\t{part_1}")
    print(f"Part 2:\t{part_2}")
