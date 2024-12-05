#!/usr/bin/env python
from __future__ import annotations
from collections import deque
from copy import deepcopy


class Amphipod:
    STARTING = 0
    HALLWAY = 1
    DESTINATION = 2

    def __init__(self, name, x, y) -> None:
        self.name = name
        self.x = x
        self.y = y
        self.destination_x = {"A": 3, "B": 5, "C": 7, "D": 9}[self.name]
        self.position = self.STARTING
        self.energy = 0

    def __str__(self) -> None:
        return f"{self.name}"

    def __repr__(self) -> None:
        return f"{self.name}[{self.position}]: ({self.x},{self.y}) -> {self.energy}"

    def update_location(self, step: Node) -> None:
        position = self.DESTINATION if step.y > 1 else self.HALLWAY
        self.update_energy(self.x, self.y, step.x, step.y, position - self.position)
        (
            self.x,
            self.y,
        ) = (
            step.x,
            step.y,
        )
        self.position = position

    def update_energy(
        self,
        current_x: int,
        current_y: int,
        destination_x: int,
        destination_y: int,
        positions,
    ) -> None:
        energy_requirements = {"A": 1, "B": 10, "C": 100, "D": 1000}
        if positions > 1 and current_x != destination_x:
            steps_taken = (
                abs(current_x - destination_x)
                + abs(current_y - 1)
                + abs(1 - destination_y)
            )
        else:
            steps_taken = abs(current_x - destination_x) + abs(
                current_y - destination_y
            )

        self.energy += steps_taken * energy_requirements[self.name]


class Node:
    def __init__(self, x, y, amphipod=None):
        self.x, self.y = x, y
        self.amphipod = amphipod
        self.down = None
        self.left = None
        self.right = None
        self.up = None

    def __str__(self):
        return str(self.amphipod) if self.amphipod else "."

    def __repr__(self):
        if self.amphipod:
            return self.amphipod
        else:
            return f"({self.x}, {self.y}): {self.amphipod}"

    def at_home(self):
        return self.y > 1 and self.room_for(self.amphipod)

    def available_home(self):
        available_or_home = True if not self.amphipod else self.room_for(self.amphipod)
        return self.y > 1 and available_or_home

    def room_for(self, amphipod: Amphipod):
        if self.y > 1 and amphipod:
            if self.x == 3 and amphipod.name == "A":
                return True
            if self.x == 5 and amphipod.name == "B":
                return True
            if self.x == 7 and amphipod.name == "C":
                return True
            if self.x == 9 and amphipod.name == "D":
                return True
        return False


class FloorPlan:
    @classmethod
    def create(cls, data: list[str]) -> FloorPlan:
        floor_plan = cls()
        floor_plan.bottom_bunk = len(data) - 2
        for y, line in enumerate(data):
            row = []
            for x, char in enumerate(line):
                if char not in ("#", " "):
                    amphipod = (
                        Amphipod(char, x, y) if char in ("A", "B", "C", "D") else None
                    )
                    row.append(Node(x, y, amphipod))
                else:
                    row.append(char)
            floor_plan.full_plan.append(row)
        return floor_plan

    def __init__(self):
        self.full_plan = []
        self.bottom_bunk = None
        self.amphipods = []
        self.history = []

    def access_list(self):
        return self.full_plan[1][:-1]

    def energy_consumed(self):
        return sum(
            map(
                lambda amphipod: amphipod.energy,
                self.amphipods,
            )
        )

    def location(self, x: int, y: int) -> Node:
        if y == 1:
            return self.access_list[x]
        else:
            step = self.access_list[x]
            for _ in range(y - 1):
                step = getattr(step, "down")
            return step

    def move(self, amphipod: Amphipod, step: Node):
        if amphipod.position == amphipod.DESTINATION:
            return
        position, x, y = amphipod.position, amphipod.x, amphipod.y
        self.location(x, y).amphipod = None
        amphipod.update_location(step)
        step.amphipod = amphipod
        self.history.append(
            f"{amphipod.name}({position}): ({x}, {y}) ->\t"
            + f"{amphipod.name}({amphipod.position}): ({step.x}, {step.y})"
            + f"\t=> {amphipod.energy})"
        )

    def move_destined(self):

        for amphipod in self.amphipods:
            if (
                amphipod.position == Amphipod.STARTING
                and amphipod.y == self.bottom_bunk
                and amphipod.x == amphipod.destination_x
            ):
                self.move(amphipod, self.location(amphipod.x, amphipod.y))

            if self.room_available(amphipod):
                if abs(amphipod.x - amphipod.destination_x) < 2:
                    self.move(amphipod, self.room_available(amphipod)[0])

                if amphipod.position != Amphipod.STARTING or (
                    amphipod.position == Amphipod.STARTING
                    and not any(
                        map(
                            lambda n: n.amphipod,
                            [
                                self.location(amphipod.x, y)
                                for y in range(1, amphipod.y)
                            ],
                        )
                    )
                ):
                    if amphipod.x < amphipod.destination_x and not any(
                        map(
                            lambda n: n.amphipod,
                            [
                                self.access_list[x]
                                for x in range(
                                    amphipod.x if amphipod.y > 1 else amphipod.x + 1,
                                    amphipod.destination_x,
                                )
                            ],
                        )
                    ):
                        self.move(amphipod, self.room_available(amphipod)[0])

                    elif amphipod.x > amphipod.destination_x and not any(
                        map(
                            lambda n: n.amphipod,
                            [
                                self.access_list[x]
                                for x in range(
                                    amphipod.destination_x,
                                    amphipod.x + 1 if amphipod.y > 1 else amphipod.x,
                                )
                            ],
                        )
                    ):
                        self.move(amphipod, self.room_available(amphipod)[0])

    def open_room(self, amphipod: Amphipod) -> bool:
        room = []
        tail = self.access_list[amphipod.destination_x]
        while tail.down:
            tail = tail.down
            room.append(tail)
        return not any(map(lambda r: r.amphipod, room))

    def open_bunk(self, amphipod: Amphipod) -> bool:
        room = []
        tail = self.access_list[amphipod.destination_x]
        while tail.down:
            tail = tail.down
            room.append(tail)
        return all(map(lambda r: r.available_home(), room))

    def next_open_bunk(self, amphipod: Amphipod) -> Node | None:
        tail = self.access_list[amphipod.destination_x]
        while tail.down:
            tail = tail.down
            if tail.amphipod:
                return tail.up
        return tail

    def possible_moves_by(self, amphipod: Amphipod) -> list(Node):
        if amphipod.position == amphipod.DESTINATION:
            return []

        if amphipod.position == Amphipod.STARTING:
            if (
                # amphipod.y == self.bottom_bunk
                # and self.access_list[amphipod.x].down.amphipod is not None
                any(
                    map(
                        lambda n: n.amphipod,
                        [self.location(amphipod.x, y) for y in range(1, amphipod.y)],
                    )
                )
            ):
                return []

            if self.room_available(amphipod):
                if amphipod.x < amphipod.destination_x and not any(
                    map(
                        lambda n: n.amphipod,
                        [
                            self.access_list[x]
                            for x in range(
                                amphipod.x,
                                amphipod.destination_x + 1,
                            )
                        ],
                    )
                ):
                    room = self.room_available(amphipod)
                    return room if room else []
                elif amphipod.x > amphipod.destination_x and not any(
                    map(
                        lambda n: n.amphipod,
                        [
                            self.access_list[x]
                            for x in range(
                                amphipod.destination_x,
                                amphipod.x + 1,
                            )
                        ],
                    )
                ):
                    room = self.room_available(amphipod)
                    return room if room else []
                else:
                    moves = []
                    for node in self.access_list[amphipod.x - 1 : 0 : -1]:
                        if node.amphipod is not None:
                            break
                        if node.x in (1, 2, 4, 6, 8, 10, 11):
                            moves.append(node)
                    for node in self.access_list[amphipod.x + 1 :]:
                        if node.amphipod is not None:
                            break
                        if node.x in (1, 2, 4, 6, 8, 10, 11):
                            moves.append(node)
                    return moves
            else:
                moves = []
                for node in self.access_list[amphipod.x - 1 : 0 : -1]:
                    if node.amphipod is not None:
                        break
                    if node.x in (1, 2, 4, 6, 8, 10, 11):
                        moves.append(node)
                for node in self.access_list[amphipod.x + 1 :]:
                    if node.amphipod is not None:
                        break
                    if node.x in (1, 2, 4, 6, 8, 10, 11):
                        moves.append(node)
                return moves

        if amphipod.position == Amphipod.HALLWAY and self.room_available(amphipod):
            if abs(amphipod.x - amphipod.destination_x) < 2:
                return self.room_available(amphipod)
            if amphipod.x < amphipod.destination_x and not any(
                map(
                    lambda n: n.amphipod,
                    [
                        self.access_list[x]
                        for x in range(
                            amphipod.x if amphipod.y > 1 else amphipod.x + 1,
                            amphipod.destination_x,
                        )
                    ],
                )
            ):
                return self.room_available(amphipod)
            if amphipod.x > amphipod.destination_x and not any(
                map(
                    lambda n: n.amphipod,
                    [
                        self.access_list[x]
                        for x in range(
                            amphipod.destination_x,
                            amphipod.x + 1 if amphipod.y > 1 else amphipod.x,
                        )
                    ],
                )
            ):
                return self.room_available(amphipod)
        return []

    def print(self):
        for row in self.full_plan:
            print("".join([str(step) for step in row]))

    def room_available(self, amphipod: Amphipod) -> list(Node):
        if self.open_room(amphipod):
            return [self.next_open_bunk(amphipod)]
        elif self.open_bunk(amphipod):
            return [self.next_open_bunk(amphipod)]
        else:
            return []

    def rooms(self):
        return [self.access_list[x] for x in (3, 5, 7, 9)]

    @staticmethod
    def room_solved(head: Node) -> bool:
        room = []
        tail = head
        while tail.down:
            tail = tail.down
            room.append(tail)
        return all(map(lambda r: r.at_home(), room))

    def solved(self) -> bool:
        return (
            sum(
                map(
                    lambda door: self.room_solved(door),
                    self.rooms(),
                )
            )
            == 4
        )


def layout() -> list(str):
    with open("./input.txt", "r") as fs:
        data = fs.read().split("\n")

    data = """#############
#...........#
###B#C#B#D###
  #A#D#C#A#  
  #########  """.split(
        "\n"
    )

    data.insert(3, list("  #D#B#A#C#  "))
    data.insert(3, list("  #D#C#B#A#  "))
    return data


def main():
    q = deque()
    minimum_score = 60000 if len(layout()) > 5 else 16000

    floor_plan = FloorPlan.create(layout())
    # floor_plan.move_destined()
    floor_plan.print()

    # test
    # floor_plan.move(floor_plan.amphipods[2], floor_plan.access_list[4])
    # floor_plan.move(floor_plan.amphipods[1], floor_plan.access_list[7])

    # test + 2 rows
    # floor_plan.move(floor_plan.amphipods[3], floor_plan.access_list[11])
    # floor_plan.move(floor_plan.amphipods[7], floor_plan.access_list[1])
    # floor_plan.move(floor_plan.amphipods[2], floor_plan.access_list[10])

    # prod
    # floor_plan.move(floor_plan.amphipods[2], floor_plan.access_list[2])
    # floor_plan.move(floor_plan.amphipods[3], floor_plan.access_list[8])

    # prod + 2
    # floor_plan.move(floor_plan.amphipods[2], floor_plan.access_list[1])
    # floor_plan.move(floor_plan.amphipods[6], floor_plan.access_list[10])
    # floor_plan.move_destined()
    # floor_plan.print()

    # for a_index, amphipod in enumerate(floor_plan.amphipods):
    #     for m, move in enumerate(floor_plan.possible_moves_by(amphipod)):
    #         fp = deepcopy(floor_plan)
    #         amphi = fp.amphipods[a_index]
    #         moves = fp.possible_moves_by(amphi)
    #         fp.move(amphi, fp.possible_moves_by(amphi)[m])
    #         q.append(fp)
    #
    # if not q:
    #     q.append(deepcopy(floor_plan))
    #
    # while q:
    #     if len(q) % 1000 == 0:
    #         print(f"queued items: {len(q)}")
    #     floor_plan = q.popleft()
    #     floor_plan.move_destined()
    #     if floor_plan.energy_consumed() > minimum_score:
    #         continue
    #     if (
    #         sum(
    #             map(
    #                 lambda a: len(floor_plan.possible_moves_by(a)), floor_plan.amphipods
    #             )
    #         )
    #         > 0
    #     ):
    #         for a_index, amphipod in enumerate(floor_plan.amphipods):
    #             for m, _ in enumerate(floor_plan.possible_moves_by(amphipod)):
    #                 fp = deepcopy(floor_plan)
    #                 amphi = fp.amphipods[a_index]
    #                 fp.move(amphi, fp.possible_moves_by(amphi)[m])
    #                 q.append(fp)
    #     else:
    #         if floor_plan.solved():
    #             if floor_plan.energy_consumed() <= minimum_score:
    #                 print()
    #                 print(f"{floor_plan.energy_consumed()} < {minimum_score}")
    #                 for amphipod in floor_plan.amphipods:
    #                     print(amphipod)
    #                 floor_plan.print()
    #                 for move in floor_plan.history:
    #                     print(move)
    #                 print()
    #             minimum_score = min([minimum_score, floor_plan.energy_consumed()])
    # print(minimum_score)


def test():
    floor_plan = FloorPlan.create(layout())
    floor_plan.current = floor_plan.access_list[7]
    for node in reversed(floor_plan):
        print(node)


if __name__ == "__main__":
    main()
