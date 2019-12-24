import sys
from queue import Queue, PriorityQueue
from utils import queue_iterator

lines = sys.stdin.readlines()

KEYS = 'abcdefghijklmnopqrstuvwxyz'
DOORS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

locations = {}
i_max = len(lines)
j_max = len(lines[0])

for i in range(i_max):
    for j in range(j_max):
        if lines[i][j] in KEYS or lines[i][j] == '@':
            locations[lines[i][j]] = (i, j)

getting_to = {}
for origin, (i, j) in locations.items():
    queue = Queue()
    queue.put((i, j, 0, []))
    visited = set()
    for (i, j, distance, doors) in queue_iterator(queue):
        if (i, j) in visited:
            continue
        visited.add((i, j))
        if i < 0 or j < 0 or i > i_max or j > j_max:
            continue
        if lines[i][j] == '#':
            continue
        if lines[i][j] in DOORS:
            doors.append(lines[i][j])
        if lines[i][j] in KEYS:
            getting_to[origin, lines[i][j]] = (distance, set(door.lower() for door in doors))
        queue.put((i, j+1, distance+1, doors.copy()))
        queue.put((i, j-1, distance+1, doors.copy()))
        queue.put((i+1, j, distance+1, doors.copy()))
        queue.put((i-1, j, distance+1, doors.copy()))

all_keys = set(locations.keys()) - {'@'}

# Gah! I tried to DFS it when I should have used Dijkstra. Somehow I didn't
# realize what I should have done until I saw a reference online, and then it
# suddenly became obvious.
visited = set()
queue = PriorityQueue()
queue.put((0, '@', ''))

for (distance, location, path) in queue_iterator(queue):
    have_keys = set(path)
    keys_string = ''.join(sorted(have_keys))
    if (location, keys_string) in visited:
        continue
    visited.add((location, keys_string))

    if have_keys == all_keys:
        print(distance, path)
        break

    for next_key in all_keys - have_keys:
        added_distance, need_keys = getting_to[location, next_key]
        if need_keys.issubset(have_keys):
            queue.put((distance + added_distance, next_key, path + next_key))
