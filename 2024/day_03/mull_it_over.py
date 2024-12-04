#!/usr/bin/python3

import os
import re

pattern = r"mul\(\d{1,3},\d{1,3}\)"

with open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "input.txt")) as file:
    lines = [line.rstrip() for line in file]

# lines = [
#     "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
# ]

total = 0
for line in lines:
    for match in re.findall(pattern, line):
        numbers = re.search(r"\((\d+),(\d+)\)", match)
        total += int(numbers.group(1)) * int(numbers.group(2))

print(f"Part 1: {total}")

total = 0
countable = True
for line in lines:
    for match in re.finditer(pattern, line):
        if match.group().startswith("do("):
            countable = True
        elif match.group().startswith("don't("):
            countable = False
        else:
            if countable:
                print(match.group())
                numbers = re.search(r"\((\d+),(\d+)\)", match.group())
                total += int(numbers.group(1)) * int(numbers.group(2))

print(f"Part 2: {total}")