import sys, math

asteroid_locations = []
for i, line in enumerate(sys.stdin.readlines()):
    asteroid_locations.extend((j, i) for j in range(len(line)) if line[j] == '#')

def direction(loc1, loc2):
    return math.atan2(loc1[1] - loc2[1], loc1[0] - loc2[0]) * 180 / math.pi

# Part I
detector = ()
detected = set()
for loc in asteroid_locations:
    current_detected = set(direction(loc2, loc) for loc2 in asteroid_locations if loc2 != loc)
    if len(detected) < len(current_detected):
        detector = loc
        detected = current_detected
print(len(detected))

# Part II
# The laser starts pointing at angle -90deg
detected = sorted(detected)
detected = [angle for angle in detected if angle >= -90] + [angle for angle in detected if angle < -90]
# Since the total number of asteroids detected is >200, we only need one sweep.
angle = detected[199]
# Print all the detected asteroids; it turns out there's only one in our input.
print(list(loc2 for loc2 in asteroid_locations if loc2 != detector and direction(loc2, detector) == angle))
