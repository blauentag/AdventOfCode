#!/usr/bin/env python


def map_discernable(digit, mappings):
    # 1, 4, 7, 8
    reverse_mappings = {v: k for k, v in mappings.items()}
    if len(digit) == 2:
        return {digit: "1"}
    elif len(digit) == 3:
        return {digit: "7"}
    elif len(digit) == 4:
        return {digit: "4"}
    elif len(digit) == 5:
        # 2, 3, 5
        if (
            len([char for char in reverse_mappings.get("1", "") if char in digit]) == 2
            or len([char for char in reverse_mappings.get("2", "") if char in digit])
            == 4
        ):
            return {digit: "3"}
        if (
            len([char for char in reverse_mappings.get("9", "") if char in digit]) == 5
            or len([char for char in reverse_mappings.get("6", "") if char in digit])
            == 5
        ):
            return {digit: "5"}
        if (
            reverse_mappings.get("9", False)
            and reverse_mappings.get("5", False)
            or len([char for char in reverse_mappings.get("3", "") if char in digit])
            == 4
        ):
            return {digit: "2"}
        return {}
    elif len(digit) == 6:
        # 0, 6, 9
        if len([char for char in reverse_mappings.get("4", "") if char in digit]) == 4:
            return {digit: "9"}
        if len([char for char in reverse_mappings.get("1", "") if char in digit]) == 2:
            return {digit: "0"}
        return {digit: "6"}
    elif len(digit) == 7:
        return {digit: "8"}
    else:
        return {}


def map_known_lengths(digit):
    if len(digit) == 2:
        return {digit: "1"}
    if len(digit) == 3:
        return {digit: "7"}
    if len(digit) == 4:
        return {digit: "4"}
    if len(digit) == 7:
        return {digit: "8"}
    return {}


def map_segments(input, mappings={}):
    for digit in input:
        mappings.update(map_known_lengths(digit))
    for digit in input:
        mappings.update(map_discernable(digit, mappings))
    return mappings


def get_output(input, mappings):
    output = []
    for digit in input:
        mappings.update(map_known_lengths(digit))
        mappings.update(map_discernable(digit, mappings))
        output.append(mappings[digit])
    return output


def map_digits(line):
    pre_pipe = line[0].split()
    post_pipe = line[-1].split()
    return get_output(post_pipe, map_segments(pre_pipe, {}))


with open("./input.txt", "r") as fs:
    lines = [segment.split("|") for segment in fs.readlines()]


sum_output_values = 0
segment_mappings = map(map_digits, lines)

for segment in segment_mappings:
    number = int("".join(segment))
    sum_output_values += int("".join(segment))

print(sum_output_values)
