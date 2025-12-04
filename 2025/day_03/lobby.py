#!/usr/bin/python3

import sys


def main(filename):
    with open(filename, "r") as file:
        banks = [[int(b) for b in line.strip()] for line in file]
        joltages_2 = [joltage_per_bank(bank, 2) for bank in banks]
        joltages_12 = [joltage_per_bank(bank, 12) for bank in banks]
        return sum(joltages_2), sum(joltages_12)


def joltage_per_bank(bank, num_of_digits):
    digits_to_remove = len(bank) - num_of_digits
    result_stack = build_stack(bank, [], digits_to_remove)
    return int("".join(map(str, result_stack[:num_of_digits])))


def remove_smaller(stack, digit, count):
    if not stack or stack[-1] >= digit or count <= 0:
        return stack, count
    else:
        return remove_smaller(stack[:-1], digit, count - 1)


def build_stack(remaining, stack, digits_to_remove):
    if not remaining:
        return stack
    digit = remaining[0]
    new_stack, new_count = remove_smaller(stack, digit, digits_to_remove)
    return build_stack(remaining[1:], new_stack + [digit], new_count)


if __name__ == "__main__":
    part_1, part_2 = main(sys.argv[1])
    print(f"Part 1:\t{part_1}")
    print(f"Part 2:\t{part_2}")
