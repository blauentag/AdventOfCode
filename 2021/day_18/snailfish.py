#!/usr/bin/env python

input = """[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]
[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]
[[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]
[[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]
[7,[5,[[3,8],[1,4]]]]
[[2,[2,2]],[8,[8,1]]]
[2,9]
[1,[[[9,3],9],[[9,0],[0,7]]]]
[[[5,[7,4]],7],1]
[[[[4,2],2],6],[8,7]]""".split(
    "\n"
)




number = []
for line in input:
    if not number:
        number = eval(line)
        continue
    number = [number, eval(line)]


def explode(num_list):
    for item in num_list:
        if type(item) == list:
            explode(item)


print(explode([7,[6,[5,[4,[3,2]]]]]))


print(number)