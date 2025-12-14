#!/usr/bin/python3

from functools import cache
import sys


def graph(filename):
    with open(filename, "r") as file:
        lines = [line.strip() for line in file.readlines() if line.strip()]
        return dict(
            [parts[0], parts[1].split()]
            for parts in [line.split(": ", 1) for line in lines]
        )


def main(filename):
    if filename == "example.txt":
        connections = graph(filename)
        connections_2 = graph("example_2.txt")
    else:
        connections = connections_2 = graph(filename)
        print(connections == connections_2)

    @cache
    def dfs(device, dac, fft):
        if device == "out" and dac and fft:
            return 1

        if (outputs := connections.get(device)) is None:
            return 0

        if device == "dac":
            dac = True

        if device == "fft":
            fft = True

        return sum(dfs(out, dac, fft) for out in outputs)

    part_1 = dfs("you", True, True)

    dfs.cache_clear()
    connections = connections_2
    part_2 = dfs("svr", False, False)

    return part_1, part_2


if __name__ == "__main__":
    part_1, part_2 = main(sys.argv[1])
    print(f"Part 1:\t{part_1}")
    print(f"Part 2:\t{part_2}")
