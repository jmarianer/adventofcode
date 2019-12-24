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
