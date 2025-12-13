#!/usr/bin/python3


import sys
from math import dist

def find_closest_point(point, points):
    return min(
        [
            (dist(p, point), p)
            for p in filter(lambda p: p[0] == point[0] or p[1] == point[1], points)
            if p != point
        ],
        default=[None],
        key=lambda dp: dp[0],
    )[-1]


def points_between_two_points(point_a, point_b):
    x1, y1 = point_a
    x2, y2 = point_b
    if x1 == x2:
        start_y, end_y = sorted([y1, y2])
        return {(x1, y) for y in range(start_y, end_y + 1)}
    else:
        start_x, end_x = sorted([x1, x2])
        return {(x, y1) for x in range(start_x, end_x + 1)}

def perimeter(previous_point, points, perimeter_local, first):
    perimeter_local |= {previous_point} if previous_point else {}
    points.remove(previous_point)
    next_point = find_closest_point(previous_point, points)
    if next_point is None:
        perimeter_local |= points_between_two_points(previous_point, first)
        return next_point, points, perimeter_local
    perimeter_local |= points_between_two_points(previous_point, next_point)
    if len(points) > 0:
        perimeter(next_point, points, perimeter_local, first)
    return next_point, points, perimeter_local


if __name__ == "__main__":
    with open(sys.argv[1], "r") as file:
        points = [tuple(map(int, line.strip().split(","))) for line in file]
    
    print(points)

    min_x = min(point[0] for point in points)
    max_x = max(point[0] for point in points)
    min_y = min(point[1] for point in points)
    max_y = max(point[1] for point in points)
    
    _, _, perimeter_set = perimeter(points[0], points, set(points), points[0])

    print()
    print(perimeter_set)
    print()

    perimeter_rows = {}
    for x, y in perimeter_set:
        perimeter_rows[y] = perimeter_rows.get(y, []) + [x]
    
    print()
    print(perimeter_rows.keys())
    print(perimeter_rows)
    print()

    rows = {}

    for y in range(min_y, max_y + 1):
        for x in range(min_x, max_x + 1):
            rows[y] = rows.get(y, []) + [x]

    print(rows.keys())
    print(rows)
    
