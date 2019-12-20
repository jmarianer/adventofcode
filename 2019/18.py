import sys
import queue as q

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

def queue_iterator(q):
    while not q.empty():
        yield q.get()

getting_to = {}
for origin, (i, j) in locations.items():
    queue = q.Queue()
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

lowest_distance = 999999
def traverse_graph(current_key, length, path):
    global lowest_distance
    if length >= lowest_distance:
        return
    have_keys = set(path)
    if have_keys == all_keys:
        lowest_distance = length
        print(length, path)
    for next_key in all_keys - have_keys:
        distance, need_keys = getting_to[current_key, next_key]
        if need_keys.issubset(have_keys):
            traverse_graph(next_key, length + distance, path + [next_key])

traverse_graph('@', 0, [])
