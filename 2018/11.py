def get_power_level(x, y, ser):
    plev = ((x + 10) * y + ser) * (x + 10)
    return (plev % 1000) // 100 - 5

SERIAL_NUMBER = 7857
power_levels = [
        [get_power_level(x, y, SERIAL_NUMBER) for y in range(301)] 
        for x in range(301)]

best = 0
coordinates = None
for size in [3]:
    for x in range(1, 300 - size + 2):
        for y in range(1, 300 - size + 2):
            total_power = sum(
                    power_levels[x+dx][y+dy]
                    #get_power_level(x+dx, y+dy, SERIAL_NUMBER)
                    for dx in range(size)
                    for dy in range(size))
            if total_power > best:
                best = total_power
                coordinates = x, y, size


print(best, coordinates)
