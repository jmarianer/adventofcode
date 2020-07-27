import sys
from copy import deepcopy

def printstate(state):
    for line in state:
        print(''.join(line))


def count(state, i, j, c):
    count = 0
    for ii in (i-1, i, i+1):
        for jj in (j-1, j, j+1):
            if state[ii][jj] == c:
                count += 1
    if state[i][j] == c:
        count -= 1

    return count


state = [['║'] + list(line.strip()) + ['║'] for line in sys.stdin.readlines()]
w = len(state[0])
h = len(state)
state = [['╔'] + ['═'] * (w - 2) + ['╗']] + state + [['╚'] + ['═'] * (w - 2) + ['╝']]

for _ in range(10):
    newstate = deepcopy(state)
    for i in range(1, h + 1):
        for j in range(1, w - 1):
            if state[i][j] == '.' and count(state, i, j, '|') >= 3:
                newstate[i][j] = '|'
            if state[i][j] == '|' and count(state, i, j, '#') >= 3:
                newstate[i][j] = '#'
            if state[i][j] == '#' and (count(state, i, j, '|') < 1 or count(state, i, j, '#') < 1):
                newstate[i][j] = '.'

    state = newstate


lumber = 0
trees = 0
for line in state:
    for char in line:
        if char == '|':
            trees += 1
        if char == '#':
            lumber += 1

print(lumber*trees)
