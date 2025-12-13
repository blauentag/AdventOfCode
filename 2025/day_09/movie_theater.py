#!/usr/bin/python3

from datetime import datetime
from math import dist

import sys
from functools import reduce
from itertools import combinations


def area(point_a, point_b):
    return (abs(point_a[0] - point_b[0]) + 1) * (abs(point_a[1] - point_b[1]) + 1)


def largest_rectangle(points):
    return reduce(
        lambda acc, a: max(acc, a), [area(a, b) for a, b in combinations(points, 2)], 0
    )


def room_coordinates(points, start_point):
    boundary_points = set(points)
    min_x = min(x for x, y in boundary_points)
    max_x = max(x for x, y in boundary_points)
    min_y = min(y for x, y in boundary_points)
    max_y = max(y for x, y in boundary_points)
    visited = boundary_points.copy()
    stack = [start_point]
    visited.add(start_point)

    directions = [(0, 1), (0, -1), (1, 0), (-1, 0)]

    while stack:
        current_x, current_y = stack.pop()

        # Check all directions
        for dx, dy in directions:
            new_x, new_y = current_x + dx, current_y + dy

            # Skip if out of bounds
            if (new_x, new_y) in boundary_points:
                continue

            # Skip if already visited
            if (new_x, new_y) in visited:
                continue

            # Check if this is a boundary point (wall)
            if (new_x, new_y) in boundary_points:
                visited.add((new_x, new_y))
                # Don't add to stack - walls are not explored further
                continue

            # Add interior point to visited set
            visited.add((new_x, new_y))
            stack.append((new_x, new_y))

    return visited


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


def is_eligible(a, b, perimeter_points):
    x1, y1 = a
    x2, y2 = b
    min_x = min(x1, x2)
    max_x = max(x1, x2)
    min_y = min(y1, y2)
    max_y = max(y1, y2)
    rectangle_points = set()
    for x in range(min_x, max_x + 1):
        for y in range(min_y, max_y + 1):
            rectangle_points.add((x, y))
    
    print(datetime.now())

    return rectangle_points.issubset(perimeter_points)


def largest_red_green_rectangle(points):
    print(datetime.now())
    _, _, perimeter_points = perimeter(points[0], points.copy(), set(points), points[0])
    top_left_perimeter = min(set(perimeter_points))
    top_left_interior = (top_left_perimeter[0] + 1, top_left_perimeter[1] + 1)
    points1 = perimeter_points.copy()
    start1 = top_left_interior
    print(datetime.now())
    result1 = room_coordinates(points1, start1)
    print(datetime.now())

    return reduce(
        lambda acc, a: max(acc, a),
        [
            area(a, b)
            for a, b in combinations(points, 2)
            if is_eligible(a, b, result1)
        ],
        0,
    )


def main(filename):
    with open(filename, "r") as file:
        points = [tuple(map(int, line.strip().split(","))) for line in file]

    return largest_rectangle(points), largest_red_green_rectangle(points)


if __name__ == "__main__":
    part_1, part_2 = main(sys.argv[1])
    print(f"Part 1:\t{part_1}")
    print(f"Part 2:\t{part_2}")
