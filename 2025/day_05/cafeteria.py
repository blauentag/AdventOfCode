#!/usr/bin/python3

import sys
from functools import reduce


def main(filename):
    with open(filename, "r") as file:
        content = file.read()

    parts = content.strip().split("\n\n")
    integers = list(map(int, parts[1].split("\n")))
    ranges = [
        range(int(n), int(m) + 1)
        for n, m in [line.split("-") for line in parts[0].split("\n")]
    ]

    return (
        sum(1 for id in integers if any(id in r for r in ranges)),
        sum(len(r) for r in merge_overlapping_ranges(ranges)),
    )


def merge_overlapping_ranges(ranges):
    if not ranges:
        return []

    sorted_ranges = sorted(ranges, key=lambda r: r.start)
    return reduce(merge_if_overlapping, sorted_ranges, [])


def merge_if_overlapping(merged, current):
    if not merged:
        return [current]

    last = merged[-1]
    if last.stop <= current.start:
        return merged + [current]

    new_start = min(last.start, current.start)
    new_stop = max(last.stop, current.stop)
    return merged[:-1] + [range(new_start, new_stop)]


if __name__ == "__main__":
    part_1, part_2 = main(sys.argv[1])
    print(f"Part 1:\t{part_1}")
    print(f"Part 2:\t{part_2}")
