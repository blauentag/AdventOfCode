#!/usr/bin/env python

from collections import deque
from copy import deepcopy


class Cave:
    def __init__(self, name):
        self.passages = []
        self.name = name
        self.visited = False
        self.one_visit_only = name[0].islower()

    def __eq__(self, other):
        return self.name == other.name

    def __repr__(self):
        return f"{self.name} -> " if self.name != "end" else f"{self.name}"

    def __str__(self):
        return f"{self.name} -> visited: {self.visited}, one_visit_only: {self.one_visit_only}, passages: {self.passages}"

    def may_visit(self):
        return not (self.one_visit_only and self.visited)

    def is_end(self):
        return self.name == "end"

    def visit(self):
        self.visited = True if self.name != "end" else False


with open("./input.txt", "r") as fs:
    cave_passage_list = [passage.strip().split("-") for passage in fs.readlines()]

# input = """fs-end
# he-DX
# fs-he
# start-DX
# pj-DX
# end-zg
# zg-sl
# zg-pj
# pj-he
# RW-he
# fs-DX
# pj-RW
# zg-RW
# start-pj
# he-WI
# zg-he
# pj-fs
# start-RW"""
# cave_passage_list = [passage.strip().split("-") for passage in input.split("\n")]

cave_set = set(cave for passage in cave_passage_list for cave in passage)

passages_map = {cave: Cave(cave) for (cave) in cave_set}
for passage in cave_passage_list:
    if passage[1] != "start" and passage[0] != "end":
        passages_map[passage[0]].passages.append(passage[1])
    if passage[0] != "start" and passage[1] != "end":
        passages_map[passage[1]].passages.append(passage[0])

for _, cave in passages_map.items():
    print(cave)
print()


class PathFinder:
    def __init__(self, caves):
        self.paths = []
        self.stack = []
        self.caves = caves

    def find(self):
        q = deque()
        path = []
        path.append(self.caves["start"])
        q.append(path.copy())
        caves = self.caves.copy()

        while q:
            print(f"NEW LOOP: {len(q)}")
            path = q.popleft()
            last = path[-1]
            print(f"\t{path} - {last}")

            if last.is_end():
                print(f"*** {path} ***")
                self.paths.append(path)

            for name in last.passages:
                cave = caves[name]
                print(f"---{cave} -> {path}")
                if cave.name[0].islower() and cave in path:
                    continue
                else:
                    if cave.may_visit():
                        print(f"---{cave} -> {path}")
                        newpath = path.copy()
                        newpath.append(cave)
                        print(len(newpath))
                        q.append(newpath)
                        print(f"----- {cave} -> {path}")


path_finder = PathFinder(passages_map)
path_finder.find()

print("\t-----\n")
for path in path_finder.paths:
    print(f"path: {path}")

print(f"\n\t{len(path_finder.paths)}")
