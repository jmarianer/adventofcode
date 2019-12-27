import sys
import queue as q
from utils import *

LETTERS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

lines = sys.stdin.readlines()
i_max = len(lines)
j_max = len(lines[0])

deltas = [
        ((0, 0), (0, 1), (0, 2)),
        ((0, 1), (0, 2), (0, 0)),
        ((0, 0), (1, 0), (2, 0)),
        ((1, 0), (2, 0), (0, 0)),
        ]
portals = {}
for i in range(i_max - 2):
    for j in range(j_max - 2):
        for d in deltas:
            if (lines[i+d[0][0]][j+d[0][1]] in LETTERS and
                    lines[i+d[1][0]][j+d[1][1]] in LETTERS and
                    lines[i+d[2][0]][j+d[2][1]] == '.'):
                portal = lines[i+d[0][0]][j+d[0][1]] + lines[i+d[1][0]][j+d[1][1]]
                this_end = (i+d[2][0], j+d[2][1])
                if portal in portals:
                    other_end = portals.pop(portal)
                    portals[this_end] = other_end
                    portals[other_end] = this_end
                else:
                    portals[portal] = this_end


# Part I
distance = {}

def nextsteps(point):
    for ns in nextsteps2d(point):
        yield ns
    if point in portals:
        yield portals[point]


def should_visit(point):
    return lines[point[0]][point[1]] == '.'


part1 = bfs_visited(
        origin=portals['AA'],
        should_visit=should_visit,
        nextsteps=nextsteps,
        destination=portals['ZZ'])

print(part1)


# Part II
i, j = portals['AA']
origin = (i, j, 0)
i, j = portals['ZZ']
destination = (i, j, 0)

def nextsteps_with_recursion(point):
    i, j, level = point
    for i1, j1 in nextsteps2d((i, j)):
        yield (i1, j1, level)
    if (i, j) in portals:
        if i == 2 or j == 2 or i == i_max - 3 or j == j_max - 4:
            if level > 0:
                i, j = portals[i, j]
                yield (i, j, level-1)
        else:
            i, j = portals[i, j]
            yield (i, j, level+1)
            


part2 = bfs_visited(
        origin=origin,
        should_visit=should_visit,
        nextsteps=nextsteps_with_recursion,
        destination=destination)

print(part2)
