orbits = {}

def indirects(p):
    if p not in orbits:
        return []
    return [orbits[p]] + indirects(orbits[p])

try:
    for line in iter(input, None):
        line = line.split(')')
        orbits[line[1]] = line[0]
except:
    # End of input
    pass

# Part I
total = 0
for p in orbits:
    total += len(indirects(p))
print(total)

# Part II
l1 = list(reversed(indirects("YOU")))
l2 = list(reversed(indirects("SAN")))
while l1[0] == l2[0]:
    l1.pop(0)
    l2.pop(0)
print (len(l1) + len(l2))
