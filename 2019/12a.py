import numpy as np
import itertools

def time_to_reset(in_pos):
    positions = np.array(in_pos)
    velocities = np.zeros(4, dtype=np.int16)

    orig_positions = positions.copy()

    for iter in itertools.count(1):
        for i in range(4):
            for j in range(4):
                if positions[i] > positions[j]:
                    velocities[i] -= 1
                if positions[i] < positions[j]:
                    velocities[i] += 1
        positions += velocities
        if (positions == orig_positions).all() and (velocities == 0).all():
            return iter

# Real input
print(np.lcm.reduce([
    time_to_reset([7, -2, 12, 5]),
    time_to_reset([10, 7, 5, -8]),
    time_to_reset([17, 0, 12, 6])]))
