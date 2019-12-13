import re, sys
from collections import defaultdict

all_steps = set()
before = defaultdict(set)

for line in sys.stdin:
    match = re.match('Step (.) must be finished before step (.) can begin.', line)
    all_steps.add(match[1])
    all_steps.add(match[2])
    before[match[1]].add(match[2])


# Part I
steps = set(all_steps)
order = ''
while len(steps) > 0:
    availablesteps = set(steps)
    for s in before.values():
        availablesteps -= s
    step = sorted(availablesteps)[0]
    order += step
    if step in before:
        before.pop(step)
    steps.remove(step)

print(order)

# Part II
