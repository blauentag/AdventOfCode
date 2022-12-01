#!/usr/bin/env python

from functools import reduce

CHUNK_CLOSERS = {"}": "{", "]": "[", ")": "(", ">": "<"}
BRACKET_CLOSERS = {"{": "}", "[": "]", "(": ")", "<": ">"}


def bracket_scoring(brackets):
    scoring = {"}": 3, "]": 2, ")": 1, ">": 4}
    return reduce(
        lambda score, bracket: score * 5 + scoring[bracket],
        brackets,
        0,
    )


def closers(stack):
    closing_list = ""
    for open_bracket in reversed(stack):
        closing_list += BRACKET_CLOSERS[open_bracket]
    return closing_list


def open_brackets(line):
    syntax_issue = True
    stack = []
    for char in line:
        if char not in CHUNK_CLOSERS.keys():
            stack.append(char)
        if char in CHUNK_CLOSERS.keys():
            last = stack.pop()
            if CHUNK_CLOSERS[char] != last:
                syntax_issue = False
                break
    if syntax_issue:
        return "".join(stack)


with open("./input.txt", "r") as fs:
    lines = fs.read().split("\n")

scores = sorted(
    list(
        map(
            bracket_scoring,
            map(
                closers,
                [stack for stack in map(open_brackets, lines) if stack]
                )
        )
    )
)

print(scores[int((len(scores) - 1) / 2)])
# 2870201088
