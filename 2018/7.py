import re, sys
from collections import defaultdict

all_steps = set()
before = defaultdict(set)

for line in sys.stdin:
    match = re.match('Step (.) must be finished before step (.) can begin.', line)
    all_steps.add(match[1])
    all_steps.add(match[2])
    before[match[1]].add(match[2])

before2 = before.copy()

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
steps = set(all_steps)
before = before2
time = 0
WORKERS = 5
workers_done = [None] * WORKERS
workers_current = [None] * WORKERS

while len(steps) > 0:
    for i, t in enumerate(workers_done):
        if t is None or t <= time:
            step = workers_current[i]
            if step is not None:
                print('Time', time, 'worker', i, 'finished step', step)
                step = workers_current[i]
                workers_current[i] = None
                workers_done[i] = None
                if step in before:
                    before.pop(step)

    for i, t in enumerate(workers_done):
        if t is None or t <= time:
            availablesteps = set(steps)
            for s in before.values():
                availablesteps -= s
            if len(availablesteps) > 0:
                step = sorted(availablesteps)[0]
                steps.remove(step)
                print('Time', time, 'worker', i, 'begins step', step)
                workers_done[i] = time + ord(step) - 4
                workers_current[i] = step

    time = min(t for t in workers_done if t is not None)

for i, t in enumerate(workers_done):
    step = workers_current[i]
    if step is not None:
        print('Time', t, 'worker', i, 'finished step', step)

print(max(t for t in workers_done if t is not None))
