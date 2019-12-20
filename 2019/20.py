import sys
import queue as q

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

print(portals)

start = portals['AA']
visited = set()
queue = q.Queue()
queue.put(start)
distance = { start: 0 }

def queue_iterator(q):
    while not q.empty():
        yield q.get()

for current in queue_iterator(queue):
    i, j = current
    next_steps = [
            (i, j+1),
            (i, j-1),
            (i+1, j),
            (i-1, j),
            ]
    if current in portals:
        next_steps.append(portals[current])

    for i, j in next_steps:
        if lines[i][j] == '.' and (i, j) not in distance:
            distance[i, j] = distance[current] + 1
            queue.put((i, j))

print(distance[portals['ZZ']])
