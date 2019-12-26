import sys
from queue import Queue

field = {}
def print_field():
    for j in range(min_j, max_j + 1):
        for i in range(min_i, max_i + 1):
            print(field[i, j] if (i, j) in field else '.', end='')
        print()


sizes = {}
locations = {}
queue = Queue()
letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
for loc, line in enumerate(line.rstrip() for line in sys.stdin):
    i, j = (int(l) for l in line.split(','))
    char = letters[loc]
    sizes[char] = 0
    locations[char] = i, j
    queue.put((i, j, char))

min_i = min(i for i, j in locations.values()) - 1
max_i = max(i for i, j in locations.values()) + 1
min_j = min(j for i, j in locations.values()) - 1
max_j = max(j for i, j in locations.values()) + 1

# Part I
for j in range(min_j, max_j + 1):
    for i in range(min_i, max_i + 1):
        manhattan_distances = sorted((abs(i-i1) + abs(j-j1), char) for char, (i1, j1) in locations.items())
        min_dist, char = manhattan_distances[0]
        next_dist, _ = manhattan_distances[1]
        if min_dist == next_dist:
            field[i, j] = '.'
        else:
            field[i, j] = char
            sizes[char] += 1

finite = set(sizes)
for j in range(min_j, max_j + 1):
    finite.discard(field[min_i, j])
    finite.discard(field[max_i, j])

for i in range(min_i, max_i + 1):
    finite.discard(field[i, min_j])
    finite.discard(field[i, max_j])

print(max(sizes[x] for x in finite))


# Part II
size = 0
for j in range(min_j, max_j + 1):
    for i in range(min_i, max_i + 1):
        total_distance = sum(abs(i-i1) + abs(j-j1) for i1, j1 in locations.values())
        if total_distance < 10000:
            size += 1

print(size)
