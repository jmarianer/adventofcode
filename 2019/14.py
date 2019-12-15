import sys, re, math
from collections import defaultdict

reactions = {}
for i in sys.stdin:
    match = re.match('(.*) => (\d+) (.+)', i)
    inputs = [i.split(' ') for i in match[1].split(', ')]
    reactions[match[3]] = int(match[2]), inputs

want = defaultdict(lambda: 0)
total = defaultdict(lambda: 0)
excess = defaultdict(lambda: 0)

want['FUEL'] = 1
while True:
    keys = set(want.keys())
    keys.discard('ORE')
    if len(keys) == 0:
        break
    item = list(keys)[0]
    count = want.pop(item)
    reaction_output, needed = reactions[item]

    reaction_count = math.ceil(count / reaction_output)
    total[item] += reaction_count
    excess[item] += reaction_count * reaction_output - count
    needed = {
            new_item: int(i) * reaction_count
            for [i, new_item] in needed
            }
    for item in needed:
        if needed[item] < excess[item]:
            excess[item] -= needed[item]
            needed[item] = 0
        else:
            needed[item] -= excess[item]
            excess[item] = 0
        want[item] += needed[item]

print(want['ORE'])
print(total)
