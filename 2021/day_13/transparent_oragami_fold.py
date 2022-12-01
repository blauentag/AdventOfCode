#!/usr/bin/env python

with open("./input.txt", "r") as fs:
    dots = fs.read().split("\n")

# dots="""6,10
# 0,14
# 9,10
# 0,3
# 10,4
# 4,11
# 6,0
# 6,12
# 4,1
# 0,13
# 10,12
# 3,4
# 3,0
# 8,4
# 1,10
# 2,14
# 8,10
# 9,0

# fold along y=7
# fold along x=5""".split("\n")

folds = []
while "," not in dots[-1]:
    line = dots.pop()
    if not line:
        continue
    folds.append(
        list(
            map(
                lambda s: int(s) if s.isnumeric() else s, line.split(" ")[-1].split("=")
            )
        )
    )

dots = list(
    map(
        tuple,
        map(
            lambda dot: [int(coord) for coord in dot], [dot.split(",") for dot in dots]
        ),
    )
)


def fold_x(paper, axis):
    left = list(filter(lambda dot: dot[0] < axis, paper))
    right = list(filter(lambda dot: dot[0] > axis, paper))
    return set(
        left + list(map(lambda dot: tuple([axis - (dot[0] - axis), dot[1]]), right))
    )


def fold_y(paper, axis):
    top = list(filter(lambda dot: dot[1] < axis, paper))
    bottom = list(filter(lambda dot: dot[1] > axis, paper))
    return set(
        top + list(map(lambda dot: tuple([dot[0], axis - (dot[1] - axis)]), bottom))
    )


def fold(paper, line):
    return list(fold_y(paper, line[1]) if line[0] == "y" else fold_x(paper, line[1]))


print(f"Part 1: {len(fold(dots, folds[-1]))}")

max_col = min(map(lambda i: i[1] if i[0] == "x" else 999999999, folds))
max_row = min(map(lambda i: i[1] if i[0] == "y" else 999999999, folds))
paper = dots
while folds:
    paper = list(fold(paper, folds.pop()))
paper = map(list, paper)
graph = [["." for col in range(max_col)] for row in range(max_row)]

for dot in paper:
    graph[dot[1]][dot[0]] = "#"

print("\nPart 2:")
for row in graph:
    print("".join(row))
