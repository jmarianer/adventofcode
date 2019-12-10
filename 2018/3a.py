import re

ids = set()

squares = [0] * 2000
for i in range(len(squares)):
    squares[i] = [0] * 2000

try:
    for claim in iter(input, None):
        match = re.match('#(\d+) @ (\d+),(\d+): (\d+)x(\d+)', claim)
        ids.add(match[1])
        for i in range(int(match[2]), int(match[2]) + int(match[4])):
            for j in range(int(match[3]), int(match[3]) + int(match[5])):
                if squares[i][j] == 0:
                    squares[i][j] = match[1]
                else:
                    ids.discard(match[1])
                    ids.discard(squares[i][j])
except EOFError:
    # End of input
    pass

print(sorted(int(id) for id in ids))
