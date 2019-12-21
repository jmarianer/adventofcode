import sys

def fuel(i, recurse=False):
    f = int(i / 3) - 2
    if f < 0:
        return 0
    return f + fuel(f, True) if recurse else f

masses = [int(i) for i in sys.stdin]

print(sum(fuel(m) for m in masses))
print(sum(fuel(m, True) for m in masses))

