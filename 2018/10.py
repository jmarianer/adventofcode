import sys

locs = []
vels = []
for loc, line in enumerate(line.rstrip() for line in sys.stdin):
    x, y, dx, dy = (int(l) for l in line.split(','))
    locs.append((x, y))
    vels.append((dx, dy))

# 10274 figured by outputing maxx-minx and taking the minimum
for time in range(10274):
    min_x = min(x for x, y in locs)
    max_x = max(x for x, y in locs)
    min_y = min(y for x, y in locs)
    max_y = max(y for x, y in locs)
    for i, (x, y) in enumerate(locs):
        dx, dy = vels[i]
        locs[i] = (x + dx, y + dy)


min_x = min(x for x, y in locs)
max_x = max(x for x, y in locs)
min_y = min(y for x, y in locs)
max_y = max(y for x, y in locs)

for y in range(min_y, max_y + 1):
    for x in range(min_x, max_x + 1):
        print('#' if (x, y) in locs else ' ', end='')
    print()
