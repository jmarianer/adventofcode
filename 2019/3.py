def locations(wire):
    cur = 0,0
    ret = [cur]
    for inst in wire.split(','):
        dir = inst[0]
        count = int(inst[1:])

        if dir == 'R':
            delta = 1,0
        elif dir == 'L':
            delta = -1,0
        elif dir == 'U':
            delta = 0,1
        elif dir == 'D':
            delta = 0,-1

        for i in range(count):
            cur = (cur[0] + delta[0], cur[1] + delta[1])
            ret.append(cur)

    return ret


wire1=input()
wire2=input()

intersections = set(locations(wire1)).intersection(set(locations(wire2)))
distances = [abs(i[0]) + abs(i[1]) for i in intersections]
print(sorted(distances)[1])
