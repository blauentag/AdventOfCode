#!/usr/bin/python3

import sys
from collections import deque
from functools import reduce
from itertools import combinations
from math import prod, sqrt


def distance_3d(point_1, point_2):
    return sqrt(
        (point_1[0] - point_2[0]) ** 2
        + (point_1[1] - point_2[1]) ** 2
        + (point_1[2] - point_2[2]) ** 2
    )


def closest_cb_boxes(points, count):
    return sorted(
        [
            (distance_3d(point_1, point_2), point_1, point_2)
            for index, point_1 in enumerate(points)
            for point_2 in points[index + 1 :]
        ],
        key=lambda dist_pt_pt: dist_pt_pt[0],
    )[:count]


def merge_with_overlaps(merged, current_set):
    overlapping_indices = [
        i for i, s in enumerate(merged) if not s.isdisjoint(current_set)
    ]
    if not overlapping_indices:
        return merged + [current_set]
    else:
        merged_set = reduce(
            lambda acc, i: acc | merged[i],
            sorted(overlapping_indices, reverse=True),
            current_set,
        )
        new_merged = [s for i, s in enumerate(merged) if i not in overlapping_indices]
        return new_merged + [merged_set]


def circuit_sizes(cb_locations, count):
    junctions = [
        set([tuple(points) for points in list(item)[-2:]])
        for item in closest_cb_boxes(cb_locations, count)
    ]

    return prod(sorted(map(len, reduce(merge_with_overlaps, junctions, [])))[-3:])


def add_connection(matrix, a, b):
    matrix = matrix.copy()
    matrix[a] = matrix.get(a, set()) | {b}
    matrix[b] = matrix.get(b, set()) | {a}
    return matrix


def create_matrix(connections, size):
    matrix = {}
    for a, b in connections[:size]:
        matrix = add_connection(matrix, a, b)
    return matrix


def expand_group(coord, group, matrix):
    visited = group.copy()
    queue = deque([coord])
    while queue:
        current = queue.popleft()
        if current not in visited:
            visited = visited | {current}
            neighbors = matrix.get(current, set())
            queue.extend(neighbors)

    return visited


def last_two(cb_locations, count):
    cb_connections = sorted(
        combinations(cb_locations, 2),
        key=lambda ps: sum((a - b) ** 2 for a, b in zip(*ps, strict=True)),
    )
    matrix = create_matrix(cb_connections, count)
    group = {cb_locations[0]}

    last_a, last_b = None, None

    for coord_a, coord_b in cb_connections[count:]:
        working_group = group.copy()
        working_matrix = matrix.copy()

        working_matrix[coord_a] = working_matrix.get(coord_a, set()) | {coord_b}
        working_matrix[coord_b] = working_matrix.get(coord_b, set()) | {coord_a}

        if coord_a in group and coord_b not in group:
            expanded_group = expand_group(coord_b, group, working_matrix)
            working_group = expanded_group
        elif coord_b in group and coord_a not in group:
            expanded_group = expand_group(coord_a, group, working_matrix)
            working_group = expanded_group

        group = working_group
        matrix = working_matrix

        if len(group) == len(cb_locations):
            break

    return coord_a[0] * coord_b[0]


def main(filename):
    count = 10 if "example.txt" == filename else 1000
    with open(filename, "r") as file:
        cb_locations = [tuple(map(int, line.split(","))) for line in file.readlines()]

    return circuit_sizes(cb_locations, count), last_two(cb_locations, count)


if __name__ == "__main__":
    part_1, part_2 = main(sys.argv[1])
    print(f"Part 1:\t{part_1}")
    print(f"Part 2:\t{part_2}")
