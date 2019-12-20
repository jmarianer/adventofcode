ELVES = 471
MAX = 720

# Current marble is first; clockwise is to the right
circle = [3, 0, 2, 1]

scores = [0]  * ELVES
for marble in range(4, MAX + 1):
    if marble % 23 == 0:
        scores[marble % ELVES] += marble + circle[-7]
        circle = circle[-6:] + circle[:-7]
    else:
        circle = [marble] + circle[2:] + circle[0:2]
    print(marble, max(scores))
