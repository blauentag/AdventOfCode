#!/usr/bin/env python

import cProfile

ITERATIONS = 40


class ExtndedPolymerization:

    def __init__(self, polymer_template, element_pairs):
        self.polymer_template = polymer_template
        self.element_pairs = element_pairs
        self.magnitude_map = element_pairs.copy()
        self.base_counts_map = element_pairs.copy()
        self.counts_map = {
            char: 0
            for char in set(
                list(self.polymer_template)
                + [char for string in self.element_pairs.values() for char in string]
            )
        }

    def base_cases(self, iterations):
        for key, polymer in self.magnitude_map.items():
            self.magnitude_map[key] = self.element_pairs[key]
            for i in range(int(iterations / 2) - 1):
                self.magnitude_map[key] = self.polymeraze(self.magnitude_map[key])

    def base_count(self):
        for template in self.element_pairs:
            counts_map = {
                char: 0
                for char in set(
                    list(self.polymer_template)
                    + [
                        char
                        for string in self.element_pairs.values()
                        for char in string
                    ]
                )
            }
            for char in self.magnitude_map[template]:
                counts_map[char] += 1

            self.base_counts_map[template] = counts_map

    def count(self, chain):
        for index, template in enumerate(self.templates(chain)):
            for key, value in self.base_counts_map[template].items():
                self.counts_map[key] += value
            if index > 0:
                self.counts_map[template[0]] -= 1

    def chain(self):
        polymers = []
        for index, template in enumerate(self.templates()):
            polymers.append(
                self.magnitude_map[template][1:]
                if index > 0
                else self.magnitude_map[template]
            )

        return "".join(polymers)

    def chain_polymers(self, iterations):
        self.base_cases(iterations)
        self.base_count()
        self.count(self.chain())
        print(self.max_minus_min())

    # def print_chain(self):
    #     polymers = []
    #     for index, template in enumerate(self.templates(self.chain())):
    #         component = (self.magnitude_map[template])[1:] if index > 0 else self.magnitude_map[template]
    #         polymers.append(component)

    #     return "".join(polymers)

    def polymeraze(self, polymer):
        blocks = [polymer[0]]
        for i in range(len(polymer) - 1):
            blocks.append(self.element_pairs[polymer[i : i + 2]][-2:])

        return "".join(blocks)

    def templates(self, polymer_template=None):
        polymer_template = polymer_template or self.polymer_template
        return [
            chunk_0 + chunk_1
            for chunk_0, chunk_1 in zip(polymer_template, polymer_template[1:])
        ]

    def max_minus_min(self):
        max = {"max": 0}
        min = {"min": 999999999999999}
        for char, count in self.counts_map.items():
            if count > list(max.values())[0]:
                max = {char: count}

            if count < list(min.values())[0]:
                min = {char: count}

        return list(max.values())[0] - list(min.values())[0]

    @staticmethod
    def parse_lines(lines):
        polymer_template = ""
        pairs = []
        for line in lines:
            if "->" in line:
                pairs.append(line.split("->"))
            if not polymer_template:
                polymer_template = line

        element_pairs = {
            pair[0].strip(): pair[0].strip()[0] + pair[1].strip() + pair[0].strip()[1]
            for pair in pairs
        }
        return [polymer_template, element_pairs]


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

    polymer_template, element_pairs = ExtndedPolymerization.parse_lines(lines)
    polymerizer = ExtndedPolymerization(polymer_template, element_pairs)

    cProfile.run("polymerizer.chain_polymers(ITERATIONS)")
