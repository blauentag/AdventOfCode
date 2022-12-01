#!/usr/bin/env python

import cProfile


def triple(pair):
    key = pair[0].strip()
    return key[0] + pair[1].strip() + key[1]


def parse_lines(lines):
    polymer_template = ""
    pairs = []
    for line in lines:
        if "->" in line:
            pairs.append(line.split("->"))
        else:
            polymer_template += line

    element_pairs = {pair[0].strip(): triple(pair) for pair in pairs}
    return [polymer_template, element_pairs]


def chaining(pairs):
    chain = ""
    for pair in pairs:
        chain += triple(pair)[1:] if chain else triple(pair)

    return chain


def polymeraze(polymer_template, element_pairs):
    blocks = [polymer_template[0]]
    for i in range(len(polymer_template) - 1):
        blocks.append(element_pairs[polymer_template[i : i + 2]][-2:])

    return "".join(blocks)


def iterate(polymer_template, element_pairs, iterations):
    polymer_chain = polymer_template
    for i in range(iterations):
        print(i)
        polymer_chain = polymeraze(polymer_chain, element_pairs)
    return max_minus_min(polymer_chain)


def max_minus_min(polymer_chain):
    counts = {}
    for char in polymer_chain:
        counts[char] = counts[char] + 1 if char in counts.keys() else 1

    max = {"max": 0}
    min = {"min": 9999999999}
    for char, count in counts.items():
        if count > list(max.values())[0]:
            max = {char: count}

        if count < list(min.values())[0]:
            min = {char: count}

    return list(max.values())[0] - list(min.values())[0]


if __name__ == "__main__":

    with open("./input.txt", "r") as fs:
        lines = fs.read().split("\n")

    # lines="""NNCB

    # CH -> B
    # HH -> N
    # CB -> H
    # NH -> C
    # HB -> C
    # HC -> B
    # HN -> C
    # NN -> C
    # BH -> H
    # NC -> B
    # NB -> B
    # BN -> B
    # BB -> N
    # BC -> B
    # CC -> N
    # CN -> C""".split("\n")

    polymer_template, element_pairs = parse_lines(lines)
    # for i in range(10):
    #     polymer_template = polymeraze(polymer_template, element_pairs)

    # print(max_minus_min(iterate(polymer_template, element_pairs, 15)))

    # iterate(polymer_template, element_pairs, 15)

    cProfile.run("print(iterate(polymer_template, element_pairs, 40))")
