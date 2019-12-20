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
                if portal == 'XF':
                    print(this_end)
                if portal in portals:
                    other_end = portals.pop(portal)
                    portals[this_end] = other_end
                    portals[other_end] = this_end
                else:
                    portals[portal] = this_end

start = portals['AA']
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


# Part II
i, j = portals['AA']
start = (i, j, 0)
i, j = portals['ZZ']
end = (i, j, 0)
queue = q.Queue()
queue.put(start)
distance = { start: 0 }

for current in queue_iterator(queue):
    i, j, level = current
    if current == end:
        print(distance[current])
        break
    next_steps = [
            (i, j+1, level),
            (i, j-1, level),
            (i+1, j, level),
            (i-1, j, level),
            ]
    if (i, j) in portals:
        if i == 2 or j == 2 or i == i_max - 3 or j == j_max - 4:
            if level > 0:
                i, j = portals[i, j]
                next_steps.append((i, j, level-1))
        else:
            i, j = portals[i, j]
            next_steps.append((i, j, level+1))


    for i, j, level in next_steps:
        if lines[i][j] == '.' and (i, j, level) not in distance:
            distance[i, j, level] = distance[current] + 1
            queue.put((i, j, level))

