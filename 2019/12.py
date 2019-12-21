import numpy as np

positions = np.array([
    [7, 10, 17],
    [-2, 7, 0],
    [12, 5, 12],
    [5, -8, 6]])

velocities = np.zeros((4,3), dtype=np.int16)

for _ in range(1000):
    for i in range(4):
        for j in range(4):
            for x in range(3):
                if positions[i][x] > positions[j][x]:
                    velocities[i][x] -= 1
                if positions[i][x] < positions[j][x]:
                    velocities[i][x] += 1
    positions += velocities

print(sum(sum(abs(positions[i])) * sum(abs(velocities[i])) for i in range(4)))
