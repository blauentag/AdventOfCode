#!/usr/bin/python3

import os


def lines():
    with open(
        os.path.join(os.path.dirname(os.path.abspath(__file__)), "input.txt")
    ) as file:
        lines = [line.rstrip() for line in file]

    # lines = [
    #     "3   4",
    #     "4   3",
    #     "2   5",
    #     "1   3",
    #     "3   9",
    #     "3   3",
    # ]

    return lines


left_list = []
right_list = []
for line in lines():
    left, right = line.split("   ")
    left_list.append(left)
    right_list.append(right)
left_list = list(map(int, sorted(left_list)))
right_list = list(map(int, sorted(right_list)))


def split(line):
    return line.split("   ")


def create_lists(lines):
    split_list = [split(line) for line in lines]
    left_list = list(map(int, sorted([x[0] for x in split_list])))
    right_list = list(map(int, sorted([x[1] for x in split_list])))
    return left_list, right_list


def part_1():
    left_list, right_list = create_lists(lines())
    return sum([abs(last - first) for last, first in zip(left_list, right_list)])


def part_2():
    left_list, right_list = create_lists(lines())
    return sum([(right_list.count(item) * item) for item in left_list])


print(f"Part 1: {part_1()}")
print(f"Part 2: {part_2()}")
