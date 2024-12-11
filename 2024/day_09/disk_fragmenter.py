#!/usr/bin/python3

import os
from functools import reduce


def disk_map():
    with open(
            os.path.join(os.path.dirname(os.path.abspath(__file__)), "input.txt")
    ) as file:
        lines: list[str] = [line.rstrip() for line in file]

    # lines = ["2333133121414131402"]

    return lines[0]


def individual_blocks(index, size):
    if index % 2 != 0:
        return ".", int(size)

    return int(index / 2), int(size)


def compress_memory(blocks):
    blocks_size = len(blocks) - 1
    for filled_index, filled_memory_block in enumerate(reversed(blocks)):
        if filled_memory_block[0] == ".":
            del blocks[blocks_size - filled_index]
            return

        for free_index, free_memory_block in enumerate(blocks):
            if free_index >= blocks_size - filled_index:
                return

            if free_memory_block[0] == ".":
                if free_memory_block[1] == filled_memory_block[1]:
                    del blocks[blocks_size - filled_index]
                    del blocks[free_index]
                    blocks.insert(free_index, filled_memory_block)
                    return

                elif free_memory_block[1] > filled_memory_block[1]:
                    del blocks[blocks_size - filled_index]
                    blocks[free_index] = (".", free_memory_block[1] - filled_memory_block[1])
                    blocks.insert(free_index, filled_memory_block)
                    return

                elif free_memory_block[1] < filled_memory_block[1]:
                    blocks[blocks_size - filled_index] = (filled_memory_block[0], filled_memory_block[1] - free_memory_block[1])
                    del blocks[free_index]
                    blocks.insert(free_index, (filled_memory_block[0], free_memory_block[1]))
                    return


def process_block(acc, block):
    if block == ".":
        return acc

    return {"checksum": acc["checksum"] + (block * acc["index"]), "index": acc["index"] + 1}


def checksum(blocks):
    return reduce(process_block, blocks, {"checksum": 0, "index": 0})["checksum"]


def filesystem_checksum(d_map):
    blocks = [individual_blocks(index, size) for index, size in enumerate(d_map)]

    while "." in {item[0] for item in blocks}:
        compress_memory(blocks)

    flattened_compressed_blocks = [
        integer
        for integer_list in [[block[0]] * block[1] for block in blocks]
        for integer in integer_list
    ]

    return sum([position * file_id for position, file_id in enumerate(flattened_compressed_blocks)])


def part_1(d_map):
    return filesystem_checksum(d_map)


def compress_memory_by_file(blocks, file_index, file_id):
    for free_index, free_block in enumerate(blocks):
        if free_index >= file_index:
            return

        if free_block[0] == ".":
            if free_block[1] < file_id[1]:
                continue

            elif free_block[1] == file_id[1]:
                blocks[free_index] = file_id
                blocks[file_index] = (".", file_id[1])
                return

            elif free_block[1] >= file_id[1]:
                blocks[file_index] = (".", file_id[1])
                blocks[free_index] = (free_block[0], free_block[1] - file_id[1])
                blocks.insert(free_index, file_id)
                return
    return


def filesystem_checksum_by_file(d_map):
    blocks = [individual_blocks(index, size) for index, size in enumerate(d_map)]
    # blocks = [block for block in blocks if block[1] > 0]

    for file_id_index in range(len(blocks)-1, -1, -1):
        file_id = blocks[file_id_index]
        if file_id[0] == ".":
            continue

        compress_memory_by_file(blocks, file_id_index, file_id)

    flattened_compressed_blocks = [
        integer if type(integer) == int else 0
        for integer_list in [[block[0]] * block[1] for block in blocks]
        for integer in integer_list
    ]

    return sum([position * file_id for position, file_id in enumerate(flattened_compressed_blocks)])


def part_2(d_map) -> int:
    return filesystem_checksum_by_file(d_map)


if __name__ == "__main__":
    print(f"Part 1: {part_1(disk_map())}")
    print(f"Part 2: {part_2(disk_map())}")

