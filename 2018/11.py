# Make it zero-based instead. All coordinates get subtracted 1.
def get_power_level(x, y, ser):
    plev = ((x + 11) * (y + 1) + ser) * (x + 11)
    return (plev % 1000) // 100 - 5

def sums(l, size):
    cur_sum = sum(l[:size])
    yield cur_sum
    for i in range(size, len(l)):
        cur_sum += l[i] - l[i - size]
        yield cur_sum

SERIAL_NUMBER = 7857
power_levels = [
        [get_power_level(x, y, SERIAL_NUMBER) for y in range(300)] 
        for x in range(300)]

coordinates = []
for size in range(1, 301):
    print(size)
    vertical_sums = [sums(power_levels[x], size) for x in range(300 - size + 1)]
    transposed_vertical = list(map(list, zip(*vertical_sums)))
    horizontal_sums = [list(sums(transposed_vertical[y], size)) for y in range(300 - size + 1)]
    coords = [(i, x+1, y+1, size) for y, h in enumerate(horizontal_sums) for x, i in enumerate(h)]
    coordinates.append(max(coords))

print(max(coordinates))
