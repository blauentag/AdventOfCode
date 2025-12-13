#!/usr/bin/python3


import sys

from collections import defaultdict
from math import prod


# def find_all_paths(graph, start, end, path=[]):
#     path = path + [start]
#     if start == end:
#         return [path]

#     if start not in graph:
#         return []

#     paths = []
#     for node in graph[start]:
#         if node not in path:
#             new_paths = [path for path in find_all_paths(graph, node, end, path) if not ends_with_repeating_subsequences(path)]
#             paths.extend(new_paths)

#     return paths


def find_all_paths(graph, start, stop, path=[]):
    path = path + [start]

    if start == stop:
        return [path]
    
    if start not in graph:
        return []
    
    all_paths = []

    for node in graph[start]:
        if node not in path:
            new_paths = find_all_paths(graph, node, stop, path)
            all_paths.extend[new_paths]
    
    return all_paths



def graph(filename):
    with open(filename, "r") as file:
        lines = [line.strip() for line in file.readlines() if line.strip()]
        return dict(
            [parts[0], parts[1].split()]
            for parts in [line.split(": ", 1) for line in lines]
        )


def part_1(filename):
    return len(find_all_paths(graph(filename), "you", "out"))


def part_2(filename):
    print("\np2\n")
    print(find_all_paths(graph(filename), "svr", "dac"))
    print("\n\tp2\n")

    return max(
        [
            prod(
                map(
                    len,
                    [
                        find_all_paths(graph(filename), "svr", "dac"),
                        find_all_paths(graph(filename), "dac", "fft"),
                        find_all_paths(graph(filename), "fft", "out"),
                    ],
                )
            ),
            prod(
                map(
                    len,
                    [
                        find_all_paths(graph(filename), "svr", "fft"),
                        find_all_paths(graph(filename), "fft", "dac"),
                        find_all_paths(graph(filename), "dac", "out"),
                    ],
                )
            ),
        ],
    )


if __name__ == "__main__":
    print(f"Part 1:\t{part_1(sys.argv[1])}")
    print(f"Part 2:\t{part_2(sys.argv[2])}")
