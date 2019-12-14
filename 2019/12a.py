import numpy as np
import itertools

def get_thing(in_pos):
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
            print(iter)
            return iter

# Example 1
print(np.lcm.reduce([
    get_thing([-1, 2, 4, 3]),
    get_thing([0, -10, -8, 5]),
    get_thing([2, -7, 8, -1])]))

# Example 2
print(np.lcm.reduce([
    get_thing([-8, 5, 2, 9]),
    get_thing([-10, 5, -7, -8]),
    get_thing([0, 10, 3, -3])]))

# Real input
print(np.lcm.reduce([
    get_thing([7, -2, 12, 5]),
    get_thing([10, 7, 5, -8]),
    get_thing([17, 0, 12, 6])]))
