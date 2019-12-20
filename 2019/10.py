import sys, math

asteroid_locations = []
for i, line in enumerate(sys.stdin.readlines()):
    asteroid_locations.extend((j, i) for j in range(len(line)) if line[j] == '#')

def direction(loc1, loc2):
    return math.atan2(loc1[1] - loc2[1], loc1[0] - loc2[0]) * 180 / math.pi

detector = ()
detected = set()
for loc in asteroid_locations:
    current_detected = set(direction(loc2, loc) for loc2 in asteroid_locations if loc2 != loc)
    if len(detected) < len(current_detected):
        detector = loc
        detected = current_detected

print(detector)
print(len(detected))

# The laser starts pointing at angle -90deg
detected = sorted(detected)
detected = [angle for angle in detected if angle >= -90] + [angle for angle in detected if angle < -90]
angle = detected[199]
print(angle)
print(list(loc2 for loc2 in asteroid_locations if loc2 != detector and direction(loc2, detector) == angle))
