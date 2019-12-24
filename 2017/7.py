import re, sys

progs = set()
nonroots = set()

linere = re.compile('(\w*) \((\d*)\)(?: -> (.*))?')
for line in sys.stdin:
    match = linere.match(line)
    progs.add(match[1])
    if match[3] is not None:
        for sub in match[3].split(', '):
            nonroots.add(sub)

print(list(progs - nonroots)[0])
