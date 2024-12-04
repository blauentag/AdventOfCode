#!/usr/bin/python3

import os


def is_linear(numbers: list[int]) -> bool:
    if numbers[0] < numbers[1]:
        return numbers == sorted(numbers)
    elif numbers[0] > numbers[1]:
        return numbers == sorted(numbers, reverse=True)
    else:
        return False


def changes_by_one_to_three(numbers: list[int]) -> bool:
    for i in range(1, len(numbers)):
        if abs(numbers[i] - numbers[i - 1]) not in [1, 2, 3]:
            return False
    return True


def is_safe(numbers: list[int]) -> bool:
    return is_linear(numbers) and changes_by_one_to_three(numbers)


def create_sublists(numbers: list[int]) -> list[list[int]]:
    result = []
    for i in range(len(numbers)):
        sublist = numbers[:i] + numbers[i + 1 :]
        result.append(sublist)
    return result


def numbers() -> list[list[int]]:
    with open(
        os.path.join(os.path.dirname(os.path.abspath(__file__)), "input.txt")
    ) as file:
        lines = [line.rstrip() for line in file]

    # lines = [
    #     "7 6 4 2 1",
    #     "1 2 7 8 9",
    #     "9 7 6 2 1",
    #     "1 3 2 4 5",
    #     "8 6 4 4 1",
    #     "1 3 6 7 9",
    # ]

    return [list(map(int, line.split(" "))) for line in lines]


def safe_tolerant(number_list: list[int]) -> int:
    if is_safe(number_list) or any(
        [is_safe(item) for item in create_sublists(number_list)]
    ):
        return 1

    return 0


def part_1(numbers: list[list[int]]) -> int:
    return sum(list(map(lambda number_list: 1 if is_safe(number_list) else 0, numbers)))


def part_2(numbers: list[list[int]]) -> int:
    return sum(list(map(lambda number_list: safe_tolerant(number_list), numbers)))


print(f"Part 1: {part_1(numbers())}")

print(f"Part 2: {part_2(numbers())}")
