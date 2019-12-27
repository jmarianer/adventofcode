import sys

field = [list(line.rstrip('\n')) for line in sys.stdin]
carts = []
vels = []

def print_field():
    for i, line in enumerate(field):
        for j, c in enumerate(line):
            if (i, j) in carts:
                print('c', end='')
            else:
                print(c, end='')
        print()
    print()

for i, line in enumerate(field):
    for j, c in enumerate(line):
        if c == '>':
            line[j] = '-'
            carts.append((i, j))
            vels.append((0, 1))
        if c == '<':
            line[j] = '-'
            carts.append((i, j))
            vels.append((0, -1))
        if c == '^':
            line[j] = '|'
            carts.append((i, j))
            vels.append((-1, 0))
        if c == 'v':
            line[j] = '|'
            carts.append((i, j))
            vels.append((1, 0))

choices = [0] * len(carts)


for step in range(200000):
    foo = [(j, i, cart) for cart, (i, j) in enumerate(carts)]
    #print_field()
    for _, _, cart in sorted(foo):
        i, j = carts[cart]
        if i < 0:
            continue
        di, dj = vels[cart]

        if field[i][j] == '/':
            di, dj = -dj, -di
        if field[i][j] == '\\':
            di, dj = dj, di
        if field[i][j] == '+':
            if choices[cart] == 0:
                di, dj = -dj, di
            elif choices[cart] == 2:
                di, dj = dj, -di
            choices[cart] += 1
            choices[cart] %= 3
        vels[cart] = di, dj

        carts[cart] = (i+di, j+dj)

        counts = [carts.count(loc) for loc in carts]
        if 2 in counts:
            cart1 = counts.index(2)
            cart2 = counts.index(2, cart1+1)
            print(tuple(reversed(carts[cart1])))
            carts[cart1] = (-1, cart1)
            carts[cart2] = (-1, cart2)

    carts_still_active = len([i for i, j in carts if i >= 0])
    #print(step, carts_still_active)
    if carts_still_active == 1:
        print([(j, i) for i, j in carts if i >= 0])
        exit()
