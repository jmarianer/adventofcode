import sys
bots = [[int(x) for x in line.split()] for line in sys.stdin.readlines()]

def in_range(coords, bot):
    dist = (abs(bot[0] - coords[0]) + 
            abs(bot[1] - coords[1]) +
            abs(bot[2] - coords[2]))
    return dist <= bot[3]


def count_in_range(coords):
    return [in_range(coords, bot) for bot in bots].count(True)


strongest = bots[0]
for bot in bots:
    if strongest[3] < bot[3]:
        strongest = bot

print([in_range(bot, strongest) for bot in bots].count(True))


def get_triples(total):
    for x in range(total + 1):
        for y in range(total - x + 1):
            z = total - x - y
            yield( x,  y,  z)
            yield( x,  y, -z)
            yield( x, -y,  z)
            yield( x, -y, -z)
            yield(-x,  y,  z)
            yield(-x,  y, -z)
            yield(-x, -y,  z)
            yield(-x, -y, -z)


best = ((0, 0, 0), count_in_range((0, 0, 0)))
for total in range(100):
    for coords in get_triples(total):
        count = count_in_range(coords)
        if count > best[1]:
            best = (coords, count)

print(best)
