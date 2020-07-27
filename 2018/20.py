import re


def longest(alts):
    l = 0
    val = ''
    for a in alts:
        if len(a) > l:
            l = len(a)
            val = a
    return val

s = input().strip()[1:-1]

for _ in range(1000000):
    m = re.search("\([NEWS|]*\)", s)
    if m is None:
        break
    alts = m[0][1:-1].split('|')
    start, end = m.span()
    s = s[:start] + longest(alts) + s[end:]


for _ in range(1000000):
    m = re.search("NS|SN|EW|WE", s)
    if m is None:
        break
    start, end = m.span()
    s = s[:start] + s[end:]

print(len(s))
