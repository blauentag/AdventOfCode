#!/usr/bin/env python


def convert(line):
    return int(str(line).strip())


soundings = list(map(convert, open('./soundings.data').readlines()))
increases = 0


for sounding, depth in enumerate(soundings):
    if sounding > 0:
        if depth > soundings[sounding - 1]:
            increases += 1


print(increases)
