#!/usr/bin/env python

from collections import deque
from copy import deepcopy

import multiprocessing


class Cave:
    def __init__(self, name):
        self.passages = []
        self.name = name
        self.visited = False
        self.one_visit_only = name[0].islower()

    def __eq__(self, other):
        return self.name == other.name

    def __gt__(self, other):
        return self.name > other.name

    def __gte__(self, other):
        return self.name >= other.name

    def __lt__(self, other):
        return self.name < other.name

    def __lte__(self, other):
        return self.name <= other.name

    def __repr__(self):
        return f"{self.name} -> " if self.name != 'end' else f"{self.name}"

    def __str__(self):
        return f"{self.name} -> visited: {self.visited}, one_visit_only: {self.one_visit_only}, passages: {self.passages}"

    def may_visit(self):
        return not (self.one_visit_only and self.visited)

    def is_end(self):
        return self.name == 'end'

    def visit(self):
        self.visited = True if self.name != 'end' else False


class Route:
    def __init__(self, path):
        self.path = path
        self.additional_used = False

    def __len__(self):
        return len(self.path)

    def __repr__(self):
        return f"{self.additional_used}, {self.path}"

    def __str__(self):
        return f"{self.additional_used}, {self.path}"

    def append(self, item):
        self.path.append(item)

    def last(self):
        return self.path[-1]

    def used(self):
        small_caves = [cave.name for cave in self.path if cave.name[0].islower() and cave.name != 'start']
        return len(small_caves) > len(set(small_caves)) + 1


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

passages_map = {cave:Cave(cave) for (cave) in cave_set}
for passage in cave_passage_list:
    if passage[1] != 'start' and passage[0] != 'end':
        passages_map[passage[0]].passages.append(passage[1])
    if passage[0] != 'start' and passage[1] != 'end':
        passages_map[passage[1]].passages.append(passage[0])


class PathFinder:
    def __init__(self, caves):
        self.paths = []
        self.stack = []
        self.caves = caves

    def find(self, cave_name, mq):
        q = deque()
        path = Route([])
        path.append(self.caves[cave_name])
        q.append(deepcopy(path))
        caves = self.caves.copy()

        while q:
            path = q.popleft()
            last = path.last()

            if last.is_end():
                self.paths.append(path)

            for name in last.passages:
                cave = caves[name]
                if cave.name[0].islower() and path.used():
                    pass
                else:
                    cave.visit()
                    newpath = deepcopy(path)
                    newpath.append(cave)
                    q.append(newpath)
        mq.put(len(self.paths))


if __name__ == '__main__':
    multiprocessing.freeze_support()

    path_finder = PathFinder(passages_map)
    jobs = []
    queue = multiprocessing.Queue()
    for name in ['D', 'f', 'g']:
        p = multiprocessing.Process(target=path_finder.find, args=(name, queue), name=name)
        jobs.append(p)
        p.start()
        for j in jobs:
            j.join()

    responses = []
    for i in range(3):
        responses.append(queue.get())
    print(responses)

# path_finder = PathFinder(passages_map)
# path_finder.find()

# print(f"\n\t{len(path_finder.paths)}")
