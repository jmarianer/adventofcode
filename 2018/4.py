import re, sys
from collections import defaultdict

curdate = None
alldates = {}

for line in sorted(sys.stdin.readlines()):
    match = re.match('\[1518-(..-..) ..:(..)] (.*)', line)
    if match[3].startswith('Guard'):
        if curdate is not None:
            alldates[curdate] = curguard, curarray
        curguard = int(match[3].split('#')[1].split(' ')[0])
        curarray = [' '] * 60
    elif match[3].startswith('falls'):
        sleepminute = int(match[2])
    elif match[3].startswith('wakes'):
        for i in range(sleepminute, int(match[2])):
            curarray[i] = '#'
    curdate = match[1]
alldates[curdate] = curguard, curarray

# Part I
guardminutes = defaultdict(lambda: 0)
for i in alldates.values():
    guardminutes[i[0]] += i[1].count('#')
maxminutes = max(guardminutes.values())
guard = [guard for guard in guardminutes if guardminutes[guard] == maxminutes][0]

days = [0] * 60
for i in alldates.values():
    if i[0] == guard:
        for j in range(60):
            if i[1][j] == '#':
                days[j] += 1
maxdays = max(days)
minute = [minute for minute in range(60) if days[minute] == maxdays][0]

print(guard * minute)


# Part II
guardminutes = defaultdict(lambda: 0)
for i in alldates.values():
    guard = i[0]
    for j in range(60):
        if i[1][j] == '#':
            guardminutes[guard, j] += 1
maxminutes = max(guardminutes.values())
guard = [guard for guard in guardminutes if guardminutes[guard] == maxminutes][0]
print(guard[0] * guard[1])
