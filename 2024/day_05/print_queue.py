#!/usr/bin/python3

import math
import os


def input() -> tuple[list[list[int]], list[list[int]]]:
    with open(
        os.path.join(os.path.dirname(os.path.abspath(__file__)), "input.txt")
    ) as file:
        lines: list[str] = [line.rstrip() for line in file]

    # lines: list[str] = [
    #     "47|53",
    #     "97|13",
    #     "97|61",
    #     "97|47",
    #     "75|29",
    #     "61|13",
    #     "75|53",
    #     "29|13",
    #     "97|29",
    #     "53|29",
    #     "61|53",
    #     "97|53",
    #     "61|29",
    #     "47|13",
    #     "75|47",
    #     "97|75",
    #     "47|61",
    #     "75|61",
    #     "47|29",
    #     "75|13",
    #     "53|13",
    #     "",
    #     "75,47,61,53,29",
    #     "97,61,53,29,13",
    #     "75,29,13",
    #     "75,97,47,61,53",
    #     "61,13,29",
    #     "97,13,75,29,47",
    # ]

    empty_string_index = lines.index("")
    rules = [
        [int(num) for num in rule.split("|")] for rule in lines[:empty_string_index]
    ]
    updates = [
        [int(num) for num in page.split(",")]
        for page in lines[empty_string_index + 1 :]
    ]
    return rules, updates


def properly_ordered(pages, rule):
    if rule[0] in pages and rule[1] in pages:
        if pages.index(rule[0]) < pages.index(rule[1]):
            return True
        else:
            return False
    else:
        return True


def part_1(rules, updates):
    return sum(
        [
            (
                pages[math.floor(len(pages) / 2)]
                if all(properly_ordered(pages, rule) for rule in rules)
                else 0
            )
            for pages in updates
        ]
    )


def swap_pages(pages, rules):
    for rule in rules:
        if not properly_ordered(pages, rule):
            pages[pages.index(rule[0])], pages[pages.index(rule[1])] = (
                pages[pages.index(rule[1])],
                pages[pages.index(rule[0])],
            )

    return pages


def swap_until(pages, rules):
    while not all(properly_ordered(pages, rule) for rule in rules):
        swap_pages(pages, rules)

    return pages


def part_2(rules, updates):
    incorrectly_ordered_updates = [pages for pages in updates if not all(properly_ordered(pages, rule) for rule in rules)]
    ordered_updates = [swap_until(pages, rules) for pages in incorrectly_ordered_updates]

    return part_1(rules, ordered_updates)


if __name__ == "__main__":
    print(f"Part 1: {part_1(*input())}")
    print(f"Part 2: {part_2(*input())}")
