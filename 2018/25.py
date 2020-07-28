import sys
locations = [tuple(int(x) for x in line.split(',')) for line in sys.stdin.readlines()]

sets = []
for loc in locations:
    clusters = set()
    for i in range(len(sets)):
        for loc2 in sets[i]:
            if sum(abs(loc[k] - loc2[k]) for k in range(4)) <= 3:
                clusters.add(i)
    if clusters:
        newset = {loc}
        for c in reversed(sorted(clusters)):
            newset |= sets.pop(c)
        sets.append(newset)
    else:
        sets.append({loc})

print(len(sets))
