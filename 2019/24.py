import more_itertools

inpt = '##.##.#.####..##.#...###.'

# Calculate adjacency matrix, which is a set of pairs (delta_level, index)
adj = [None] * 25
for i in range(25):
    adj[i] = set()
    # Same level adjacent
    if i >= 5:
        adj[i].add((0, i - 5))
    if i < 20:
        adj[i].add((0, i + 5))
    if i % 5 > 0:
        adj[i].add((0, i - 1))
    if i % 5 < 4:
        adj[i].add((0, i + 1))

    # Adjacent in shallower matrix
    if i <= 4:
        adj[i].add((-1, 7))
    if i >= 20:
        adj[i].add((-1, 17))
    if i % 5 == 0:
        adj[i].add((-1, 11))
    if i % 5 == 4:
        adj[i].add((-1, 13))

# Adjacent in deeper matrix
adj[7].update({(1, 0), (1, 1), (1, 2), (1, 3), (1, 4)})
adj[17].update({(1, 20), (1, 21), (1, 22), (1, 23), (1, 24)})
adj[11].update({(1, 0), (1, 5), (1, 10), (1, 15), (1, 20)})
adj[13].update({(1, 4), (1, 9), (1, 14), (1, 19), (1, 24)})


# Part I
state = inpt
states = set([state])

while True:
    newstate = list(state)
    for i in range(25):
        total_adjacent = sum(
                state[j] == '#'
                for delta_level, j in adj[i]
                if delta_level == 0)
        if state[i] == '#' and total_adjacent != 1:
            newstate[i] = '.'
        if state[i] == '.' and total_adjacent in {1, 2}:
            newstate[i] = '#'
    state = ''.join(newstate)
    if state in states:
        break
    states.add(state)

print(sum(2**i for i in range(25) if state[i] == '#'))


# Part II
state = {0: inpt}

for _ in range(200):
    # Add levels if necessary
    if state[min(state)] != '.' * 25:
        state[min(state) - 1] = '.' * 25
    if state[max(state)] != '.' * 25:
        state[max(state) + 1] = '.' * 25

    newstate = { level: list(s) for level, s in state.items() }
    for level in state:
        for i in range(25):
            # Always skip middle cells
            if i == 12:
                continue

            total_adjacent = sum(
                    state[level + delta_level][j] == '#'
                    for delta_level, j in adj[i]
                    if level + delta_level in state)

            if state[level][i] == '#' and total_adjacent != 1:
                newstate[level][i] = '.'
            if state[level][i] == '.' and total_adjacent in {1, 2}:
                newstate[level][i] = '#'

    state = { level: ''.join(s) for level, s in newstate.items() }

print(sum(state[level][i] == '#' for level in state for i in range(25)))
