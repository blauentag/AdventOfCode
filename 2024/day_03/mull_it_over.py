#!/usr/bin/python3

import os
import re


def lines():
    with open(
        os.path.join(os.path.dirname(os.path.abspath(__file__)), "input.txt")
    ) as file:
        lines = [line.rstrip() for line in file]

    # lines = [
    #     "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
    # ]

    # lines = [
    #     "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
    # ]

    return lines


def multiple(match):
    numbers = re.search(r"\((\d+),(\d+)\)", match)
    return int(numbers.group(1)) * int(numbers.group(2))


def find_muls(line):
    return sum(
        [multiple(match) for match in re.findall(r"mul\(\d{1,3},\d{1,3}\)", line)]
    )


def part_1(lines):
    return sum([find_muls(line) for line in lines])


class Part2:
    def __init__(self, countable=True):
        self.countable = countable

    def run(self, lines):
        return sum([self.blargh(line) for line in lines])

    def blech(self, pattern_match):
        if pattern_match.group().startswith("do("):
            self.countable = True

        elif pattern_match.group().startswith("don't("):
            self.countable = False

        else:
            if self.countable:
                numbers = re.search(r"\((\d+),(\d+)\)", pattern_match.group())
                return int(numbers.group(1)) * int(numbers.group(2))

        return 0

    def blargh(self, line):
        return sum(
            [
                self.blech(pattern_match)
                for pattern_match in re.finditer(
                    r"mul\(\d{1,3},\d{1,3}\)|do\(\)|don't\(\)", line
                )
            ]
        )


print(f"Part 1: {part_1(lines())}")
print(f"Part 2: {Part2().run(lines())}")
