total = 0

try:
    for line in iter(input, None):
        total += int(line)
except:
    # End of input
    pass

print(total)
