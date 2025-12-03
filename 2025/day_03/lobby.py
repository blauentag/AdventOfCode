#!/usr/bin/python3

import sys


def main(filename):
    with open(filename, "r") as file:
        banks = [[int(battery) for battery in list(line.strip())] for line in file]
        joltages_2 = [joltage_per_bank(bank, 2) for bank in banks]
        joltages_12 = [joltage_per_bank(bank, 12) for bank in banks]
        return sum(joltages_2), sum(joltages_12)


def joltage_per_bank(bank, num_of_digits):
    stack = []
    digits_to_remove = len(bank) - num_of_digits

    for digit in bank:
        while stack and stack[-1] < digit and digits_to_remove > 0:
            stack.pop()
            digits_to_remove -= 1
        stack.append(digit)

    return int("".join(map(str, stack[:num_of_digits])))


if __name__ == "__main__":
    part_1, part_2 = main(sys.argv[1])
    print(f"Part 1:\t{part_1}")
    print(f"Part 2:\t{part_2}")
