import sys

status = next(sys.stdin).rstrip()
start = 0
spread = {}
for line in sys.stdin:
    f, t = line.rstrip().split(' => ')
    spread[f] = t

seen = {}
for time in range(200):
    # Part I
    plants = [l + start for l, x in enumerate(status) if x == '#']
    if time == 20:
        print(sum(plants))
    print(time, sum(plants))

    #if status in seen:
        #break
    seen[status] = (time, start)


    status = '....' + status + '....'
    start -= 4
    next_status = list(status)
    for i in range(len(status) - 2):
        f = status[i:i+5]
        if f in spread:
            next_status[i+2] = spread[f]
        else:
            next_status[i+2] = '.'
    status = ''.join(next_status).rstrip('.')
    while status.startswith('.'):
        start += 1
        status = status[1:]

# Part II
#print(time, start, seen[status], sum(plants), len(plants))
#prev_time, prev_start = seen[status]

print(669+26*50000000000)
