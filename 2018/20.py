import re


def longest(alts):
    l = 0
    val = ''
    for a in alts:
        if len(a) > l:
            l = len(a)
            val = a
    return val

s = input().strip()[1:-1]
orig_s = s

for _ in range(1000000):
    m = re.search("\([NEWS|]*\)", s)
    if m is None:
        break
    alts = m[0][1:-1].split('|')
    start, end = m.span()
    s = s[:start] + longest(alts) + s[end:]


for _ in range(1000000):
    m = re.search("NS|SN|EW|WE", s)
    if m is None:
        break
    start, end = m.span()
    s = s[:start] + s[end:]

print(len(s))


grid = []
for _ in range(50):
    grid.append(['#'] * 50)
print(s)

def populategrid(i, j, s):
    print(i,j)
    if grid[i][j] != '#':
        return
    grid[i][j] = '.'
    if s == '':
        return
    if s[0] == 'N':
        grid[i-1][j] = '-'
        populategrid(i-2, j, s[1:])
    if s[0] == 'S':
        grid[i+1][j] = '-'
        populategrid(i+2, j, s[1:])
    if s[0] == 'W':
        grid[i][j-1] = '|'
        populategrid(i, j-2, s[1:])
    if s[0] == 'E':
        grid[i][j+1] = '|'
        populategrid(i, j+2, s[1:])

populategrid(25, 25, s)
grid[25][25] = 'S'
for line in grid:
    print(''.join(line))
