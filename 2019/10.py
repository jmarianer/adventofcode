import sys
from fractions import Fraction

asteroid_locations = []
for i, line in enumerate(sys.stdin.readlines()):
    asteroid_locations.extend((i, j) for j in range(len(line)) if line[j] == '#')

def slope(loc1, loc2):
    if loc1[1] == loc2[1]:
        return 'up' if loc2[0] - loc1[0] > 0 else 'down'
    
    dir = 'left' if loc2[1] - loc1[1] > 0 else 'right'
    return (dir, Fraction(loc1[0] - loc2[0], loc1[1] - loc2[1]))

detected = []
for loc in asteroid_locations:
    detected.append(len(set(slope(loc2, loc) for loc2 in asteroid_locations if loc2 != loc)))

print(max(detected))
