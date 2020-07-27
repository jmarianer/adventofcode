import sys
from copy import deepcopy


def state2str(state):
    return ''.join(''.join(line) for line in state)


def printstate(state):
    for line in state:
        print(''.join(line))


def printvalue(state):
    lumber = 0
    trees = 0
    for line in state:
        for char in line:
            if char == '|':
                trees += 1
            if char == '#':
                lumber += 1

    print(lumber*trees)


def count(state, i, j, c):
    count = 0
    for ii in (i-1, i, i+1):
        for jj in (j-1, j, j+1):
            if state[ii][jj] == c:
                count += 1
    if state[i][j] == c:
        count -= 1

    return count


def oneminute(state):
    newstate = deepcopy(state)
    for i in range(1, h + 1):
        for j in range(1, w - 1):
            if state[i][j] == '.' and count(state, i, j, '|') >= 3:
                newstate[i][j] = '|'
            if state[i][j] == '|' and count(state, i, j, '#') >= 3:
                newstate[i][j] = '#'
            if state[i][j] == '#' and (count(state, i, j, '|') < 1 or count(state, i, j, '#') < 1):
                newstate[i][j] = '.'
    return newstate


# Box drawing is so that we don't need to worry about overflow. Also it makes
# printing prettier, and me nostalgic for the DOS days.
state = [['║'] + list(line.strip()) + ['║'] for line in sys.stdin.readlines()]
w = len(state[0])
h = len(state)
state = [['╔'] + ['═'] * (w - 2) + ['╗']] + state + [['╚'] + ['═'] * (w - 2) + ['╝']]

# Part I
for it in range(10):
    state = oneminute(state)
printvalue(state)

# Part II
seenstates = {}
for it in range(10, 10000):
    state = oneminute(state)
    mystr = state2str(state)
    if mystr in seenstates:
        break

    seenstates[mystr] = it

looplength = it - seenstates[mystr]
it += int((1000000000 - it) / looplength) * looplength
for it in range(it + 1, 1000000000):
    state = oneminute(state)
printvalue(state)
