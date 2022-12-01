#!/usr/bin/env python

with open("./input.txt", "r") as f:
    lines = f.readlines()

number_call = list(map(int, lines[0].split(",")))


def card_offset(card_number):
    return (card_number - 1) * 6 + 2


cards = []
card_number = 1
card_count = int(len(lines) / 6)
while card_number <= card_count:
    rows = []
    offset = card_offset(card_number)
    card_string = lines[offset : offset + 5]
    for row in card_string:
        rows = rows + [list(map(int, row.strip().split()))]
    columns = list(map(list, zip(*rows[::1])))
    card = rows + columns
    cards.append(card)
    card_number += 1

done = False
for number in number_call:
    removable_card_indexes = []
    if len(cards) == 0:
        break
    for index, card in enumerate(cards):
        bingo = False
        for bingo_opportunity in card:
            if number in bingo_opportunity:
                bingo_opportunity.remove(number)
            if len(bingo_opportunity) == 0:
                bingo = True

        if bingo:
            removable_card_indexes.append(index)

    if len(cards) < 2:
        remaining_sum = int(sum(sum(cards[0], [])) / 2)
        score = number * remaining_sum
        print(score)

    if len(removable_card_indexes) > 0:
        removable_card_indexes.reverse()
        for index in removable_card_indexes:
            del cards[index]
