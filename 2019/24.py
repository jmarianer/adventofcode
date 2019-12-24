import more_itertools

inpt = '##.##.#.####..##.#...###.'

# Part I
state = inpt
states = set([state])

adj = [None] * 25
for i in range(25):
    adj[i] = []
    if i >= 5:
        adj[i].append(i-5)
    if i < 20:
        adj[i].append(i+5)
    if i % 5 > 0:
        adj[i].append(i-1)
    if i % 5 < 4:
        adj[i].append(i+1)

while True:
    newstate = list(state)
    for i in range(25):
        totadj = sum(state[j] == '#' for j in adj[i])
        if state[i] == '#' and totadj != 1:
            newstate[i] = '.'
        if state[i] == '.' and totadj in {1, 2}:
            newstate[i] = '#'
    state = ''.join(newstate)
    if state in states:
        break
    states.add(state)

print(sum(2**i for i in range(25) if state[i] == '#'))


# Part II
state = {0: inpt}

adj = [None] * 25
for i in range(25):
    adj[i] = set()
    if i >= 5:
        adj[i].add(i-5)
    if i < 20:
        adj[i].add(i+5)
    if i % 5 > 0:
        adj[i].add(i-1)
    if i % 5 < 4:
        adj[i].add(i+1)
    adj[i].discard(12)

for _ in range(200):
    if state[min(state)] != '.' * 25:
        state[min(state) - 1] = '.' * 25
    if state[max(state)] != '.' * 25:
        state[max(state) + 1] = '.' * 25
    newstate = { level: list(s) for level, s in state.items() }

    for level in state:
        for i in range(25):
            if i == 12:
                continue

            totadj = sum(state[level][j] == '#' for j in adj[i])
            if level > min(state):
                if i <= 4:
                    totadj += state[level - 1][7] == '#'
                if i >= 20:
                    totadj += state[level - 1][17] == '#'
                if i % 5 == 0:
                    totadj += state[level - 1][11] == '#'
                if i % 5 == 4:
                    totadj += state[level - 1][13] == '#'

            if level < max(state):
                if i == 7:
                    totadj += sum(state[level + 1][j] == '#' for j in (0, 1, 2, 3, 4))
                if i == 17:
                    totadj += sum(state[level + 1][j] == '#' for j in (20, 21, 22, 23, 24))
                if i == 11:
                    totadj += sum(state[level + 1][j] == '#' for j in (0, 5, 10, 15, 20))
                if i == 13:
                    totadj += sum(state[level + 1][j] == '#' for j in (4, 9, 14, 19, 24))


            if state[level][i] == '#' and totadj != 1:
                newstate[level][i] = '.'
            if state[level][i] == '.' and totadj in {1, 2}:
                newstate[level][i] = '#'

    state = { level: ''.join(s) for level, s in newstate.items() }

                    
print(sum(state[level][i] == '#' for level in state for i in range(25)))
