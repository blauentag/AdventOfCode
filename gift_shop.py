import sys

def main(filename):
    with open(filename, 'r') as file:
        lines = file.readlines()

    id_ranges = []
    for line in lines:
        parts = line.strip().split('-')
        if len(parts) == 2:
            id_first = int(parts[0])
            id_last = int(parts[1])
            id_ranges.append((id_first, id_last))

    part_1 = 0
    for id_range in id_ranges:
        id_first, id_last = id_range
        for id in range(id_first, id_last + 1):
            part_1 += 1

    return part_1

if __name__ == '__main__':
    if len(sys.argv) <= 1:
        print("USAGE : %s <target_filename> \n" % sys.argv[0])
        sys.exit(0)

    file_name = sys.argv[1]
    result = main(file_name)
    print(result)
