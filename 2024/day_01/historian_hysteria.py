#!/usr/bin/python3

import os

with open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "input.txt")) as file:
    lines = [line.rstrip() for line in file]

# lines = [
#     "3   4",
#     "4   3",
#     "2   5",
#     "1   3",
#     "3   9",
#     "3   3",
# ]

left_list = []
right_list = []
for line in lines:
    left, right = line.split("   ")
    left_list.append(left)
    right_list.append(right)
left_list = list(map(int, sorted(left_list)))
right_list = list(map(int, sorted(right_list)))

print(f"Part 1: {sum([abs(last - first) for last, first in zip(left_list, right_list)])}")
print(f"Part 2: {sum([(right_list.count(item) * item) for item in left_list])}")

