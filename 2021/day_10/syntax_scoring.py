#!/usr/bin/env python

from functools import reduce

CHUNK_CLOSERS = {"}": "{", "]": "[", ")": "(", ">": "<"}

with open("./input.txt", "r") as fs:
    lines = fs.readlines()


def corrupt_lines(line):
    stack = []
    for char in line:
        if char not in CHUNK_CLOSERS.keys():
            stack.append(char)
        if char in CHUNK_CLOSERS.keys():
            last = stack.pop()
            if CHUNK_CLOSERS[char] != last:
                return char


print(
    reduce(
        lambda sum, score: sum + score,
        map(
            lambda char: {"}": 1197, "]": 57, ")": 3, ">": 25137}[char],
            [
                corrupt_bracket
                for corrupt_bracket in map(corrupt_lines, lines)
                if corrupt_bracket
            ],
        ),
    )
)

# 364389
