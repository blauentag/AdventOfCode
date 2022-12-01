#!/usr/bin/env python
from copy import deepcopy

player_1 = {"position": 8, "score": 0}
player_2 = {"position": 1, "score": 0}

players = [player_1, player_2]
die = 1
while player_1["score"] < 1000 and player_2["score"] < 1000:
    for player in players:
        start, die = die, die + 3
        rolls = sum(list(range(start, die)))
        score = player["position"] + rolls
        score = 10 if score % 10 == 0 else int(str(score)[-1])
        player["position"] = score
        player["score"] += score
        if player["score"] >= 1000:
            break

rolls = die - 1
losing_score = min([player["score"] for player in players])
print(f"{rolls} * {losing_score} = {rolls * losing_score}")


# def play(players):
#     turn_queue = []
#     print(players)
#     for p1_roll in range(1, 4):
#         p1 = deepcopy(players[0])
#         score = p1["position"] + p1_roll
#         score = 10 if score % 10 == 0 else int(str(score)[-1])
#         p1["position"] = score
#         p1["score"] += score
#         if p1["score"] >= 21:
#             turn_queue.append([p1, deepcopy(players[-1])])
#             continue
#         for p2_roll in range(1, 4):
#             p2 = deepcopy(players[-1])
#             score = p2["position"] + p2_roll
#             score = 10 if score % 10 == 0 else int(str(score)[-1])
#             p2["position"] = score
#             p2["score"] += score
#             turn_queue.append([p1, p2])
#     return turn_queue


# def multiverse_play():
#     player_1_wins = 0
#     player_2_wins = 0
#     player_1 = {"position": 4, "score": 0}
#     player_2 = {"position": 8, "score": 0}
#     players = [player_1, player_2]
#     queue = play(players)

#     while queue:
#         players = queue.pop(0)
#         if len(queue) % 1000 == 0:
#             print("qlen", len(queue))
#         if players[0]["score"] >= 21:
#             player_1_wins += 1
#             break
#         elif players[-1]["score"] >= 21:
#             player_2_wins += 1
#             break
#         else:
#             queue += play(players)
#             print(len(queue))

#     print(f"player_1_wins: {player_1_wins}")
#     print(f"player_2_wins: {player_2_wins}")
#     return max([player_1_wins, player_2_wins])


# print()
# print(multiverse_play())




# 9225 < answer