import re

squares = [0] * 2000
for i in range(len(squares)):
    squares[i] = [0] * 2000

try:
    for claim in iter(input, None):
        match = re.match('#\d+ @ (\d+),(\d+): (\d+)x(\d+)', claim)
        for i in range(int(match[1]), int(match[1]) + int(match[3])):
            for j in range(int(match[2]), int(match[2]) + int(match[4])):
                squares[i][j] += 1
except:
    # End of input
    pass

tot = 0
for i in squares:
    for j in i:
        if j > 1:
            tot += 1

print(tot)
