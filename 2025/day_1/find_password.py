#!/usr/bin/python3

import sys

def password(filename):
    stops_on_zero = dial_points_to_zero = 0
    dial_position = 50

    with open(filename, "r") as instructions:
        for instruction in instructions:
            distance = int(instruction.replace("L", "-").replace("R", ""))
            dial_at_zero = dial_position == 0
            dial_rotations, dial_position = divmod(dial_position + distance, 100)
            dial_points_to_zero += abs(dial_rotations)

            if 0 == dial_position:
                stops_on_zero += 1

            if 0 > distance:
                dial_points_to_zero += (dial_position == 0) - dial_at_zero
    
    return stops_on_zero, dial_points_to_zero

if __name__ == "__main__":
    part_1, part_2 = password(sys.argv[1])
    print(f"Part 1:\t{part_1}")
    print(f"Part 2:\t{part_2}")