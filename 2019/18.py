import sys
from queue import Queue, PriorityQueue
from utils import queue_iterator

lines = sys.stdin.readlines()
i_max = len(lines)
j_max = len(lines[0])

KEYS = 'abcdefghijklmnopqrstuvwxyz'
DOORS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

def calc_getting_to():
    key_locations = {}
    for i in range(i_max):
        for j in range(j_max):
            if lines[i][j] in KEYS or lines[i][j] in set('@0123'):
                key_locations[lines[i][j]] = (i, j)
    all_keys = set(k for k in key_locations.keys() if k in KEYS)

    getting_to = {}
    for origin, (i, j) in key_locations.items():
        queue = Queue()
        queue.put((i, j, 0, [], ''))
        visited = set()
        for i, j, distance, doors, keys in queue_iterator(queue):
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
                getting_to[origin, lines[i][j]] = (distance, set(door.lower() for door in doors), set(keys))
                keys += lines[i][j]
            queue.put((i, j+1, distance+1, doors.copy(), keys))
            queue.put((i, j-1, distance+1, doors.copy(), keys))
            queue.put((i+1, j, distance+1, doors.copy(), keys))
            queue.put((i-1, j, distance+1, doors.copy(), keys))
    return getting_to, all_keys


# Part I
# Gah! I tried to DFS it when I should have used Dijkstra. Somehow I didn't
# realize what I should have done until I saw a reference online, and then it
# suddenly became obvious.
visited = set()
queue = PriorityQueue()
queue.put((0, ''))

getting_to, all_keys = calc_getting_to()
for (distance, path) in queue_iterator(queue):
    current_key = '@' if path == '' else path[-1]

    have_keys = set(path)
    keys_string = ''.join(sorted(have_keys))
    if (current_key, keys_string) in visited:
        continue
    visited.add((current_key, keys_string))

    if have_keys == all_keys:
        print(distance, path)
        break

    for next_key in all_keys - have_keys:
        if (current_key, next_key) in getting_to:
            added_distance, need_keys, new_keys = getting_to[current_key, next_key]
            if need_keys.issubset(have_keys) and new_keys.issubset(have_keys):
                queue.put((distance + added_distance, path + next_key))


# Part II
first = True
for i, line in enumerate(lines):
    if '.@.' in line:
        j = line.find('.@.')

        lines[i] = lines[i][:j] + '###' + lines[i][j+3:]
        lines[i-1] = lines[i-1][:j] + '0#1' + lines[i-1][j+3:]
        lines[i+1] = lines[i+1][:j] + '2#3' + lines[i+1][j+3:]

        break


visited = set()
queue = PriorityQueue()
queue.put((0, ['', '', '', '']))

getting_to, all_keys = calc_getting_to()
for (distance, paths) in queue_iterator(queue):
    current_keys = tuple(str(i) if path == '' else path[-1] for i, path in enumerate(paths))

    have_keys = set(key for path in paths for key in path if key in all_keys)
    keys_string = ''.join(sorted(have_keys))
    if (current_keys, keys_string) in visited:
        continue
    visited.add((current_keys, keys_string))

    if have_keys == all_keys:
        print(distance, paths)
        break

    for i, current_key in enumerate(current_keys):
        for next_key in all_keys - have_keys:
            if (current_key, next_key) in getting_to:
                added_distance, need_keys, new_keys = getting_to[current_key, next_key]
                if need_keys.issubset(have_keys) and new_keys.issubset(have_keys):
                    paths1 = paths.copy()
                    paths1[i] = paths1[i] + next_key
                    queue.put((distance + added_distance, paths1))
