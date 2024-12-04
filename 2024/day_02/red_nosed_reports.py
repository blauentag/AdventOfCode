#!/usr/bin/python3

import os

def is_linear(numbers):
    if numbers[0] < numbers[1]:
        return numbers == sorted(numbers)
    elif numbers[0] > numbers[1]:
        return numbers == sorted(numbers, reverse=True)
    else:
        return False


def changes_by_one_to_three(numbers):
    for i in range(1, len(numbers)):
        if abs(numbers[i] - numbers[i - 1]) not in [1, 2, 3]:
            return False
    return True


def is_safe(numbers):
    return is_linear(numbers) and changes_by_one_to_three(numbers)


def create_sublists(numbers):
  result = []
  for i in range(len(numbers)):
    sublist = numbers[:i] + numbers[i + 1:]
    result.append(sublist)
  return result


with open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "input.txt")) as file:
    lines = [line.rstrip() for line in file]

# lines = [
#     "7 6 4 2 1",
#     "1 2 7 8 9",
#     "9 7 6 2 1",
#     "1 3 2 4 5",
#     "8 6 4 4 1",
#     "1 3 6 7 9",
# ]

safe_count = 0
for line in lines:
    number_list = list(map(int, line.split(" ")))
    if is_safe(number_list):
        safe_count += 1

print(f"Part 1: {safe_count}")

safe_count = 0
for line in lines:
    number_list = list(map(int, line.split(" ")))
    if is_safe(number_list):
        safe_count += 1
    else:
        if any([is_safe(item) for item in create_sublists(number_list)]):
            safe_count += 1

print(f"Part 2: {safe_count}")
