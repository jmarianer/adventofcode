def fuel(i):
    f = int(i / 3) - 2
    if f < 0:
        return 0
    # For part I:
    # return f
    return f + fuel(f)

total_fuel = 0
try:
    for line in iter(input, None):
        total_fuel += fuel(int(line))
except:
    # End of input
    pass

print(total_fuel)

