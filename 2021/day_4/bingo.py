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


bingo = False
for number in number_call:
    if bingo:
        break
    for card in cards:
        if bingo:
            break
        for index, bingo_opportunity in enumerate(card):
            if number in bingo_opportunity:
                bingo_opportunity.remove(number)
            if len(bingo_opportunity) == 0:
                bingo = True
        if bingo:
            sum_unmarked = int(sum(sum(card, [])) / 2)
            print(number * sum_unmarked)  # 10374
            break
