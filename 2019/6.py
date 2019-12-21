import sys

orbits = {}

def indirects(p):
    if p not in orbits:
        return []
    return [orbits[p]] + indirects(orbits[p])

for line in sys.stdin:
    line = line.rstrip().split(')')
    orbits[line[1]] = line[0]

# Part I
print(sum(len(indirects(p)) for p in orbits))

# Part II
l1 = list(reversed(indirects("YOU")))
l2 = list(reversed(indirects("SAN")))
while l1[0] == l2[0]:
    l1.pop(0)
    l2.pop(0)
print (len(l1) + len(l2))
