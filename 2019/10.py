import sys
from fractions import Fraction

asteroid_locations = []
for i, line in enumerate(sys.stdin.readlines()):
    asteroid_locations.extend((j, i) for j in range(len(line)) if line[j] == '#')

def direction(loc1, loc2):
    if loc1[1] == loc2[1]:
        return (-1, 0) if loc2[0] > loc1[0] else (1, 0)
    
    frac = Fraction(loc1[0] - loc2[0], loc1[1] - loc2[1])
    dir = -1 if loc2[1] > loc1[1] else 1
    return (dir * frac.numerator, dir * frac.denominator)

detector = ()
detected = set()
for loc in asteroid_locations:
    current_detected = set(direction(loc2, loc) for loc2 in asteroid_locations if loc2 != loc)
    if len(detected) < len(current_detected):
        detector = loc
        detected = current_detected

print(detector)
print(len(detected))
