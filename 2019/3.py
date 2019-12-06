def locations(wire):
    cur = 0,0
    dist = 0
    ret = {cur: dist}
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
            cur = cur[0] + delta[0], cur[1] + delta[1]
            dist += 1
            if cur not in ret:
                ret[cur] = dist

    return ret


wire1=locations(input())
wire2=locations(input())

intersections = set(wire1).intersection(wire2)

# Part I
distances = [abs(i[0]) + abs(i[1]) for i in intersections]
print(sorted(distances)[1])

# Part II
timings = [wire1[i] + wire2[i] for i in intersections]
print(sorted(timings)[1])
