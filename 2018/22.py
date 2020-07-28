from utils import dijkstra_visited

mod = 20183

# Test data
#depth = 510
#tx = 10
#ty = 10
depth = 5913
tx = 8
ty = 701

def e_level(geo):
    return (geo + depth) % mod

def print_row(row):
    print(''.join('.=|'[e_level(geo) % 3] for geo in row))

grid = [[x * 16807 % mod for x in range(tx+100)]]
total = 0
for y in range(1, ty+100):
    grid.append([y * 48271 % mod])
    for x in range(1, tx+100):
        grid[-1].append(e_level(grid[-1][-1]) * e_level(grid[-2][x]) % mod)

grid[ty][tx] = 0
print(sum(e_level(grid[y][x]) % 3 for x in range(tx+1) for y in range(ty+1)))

exit()

# Part II in development
def next_steps(cur):
    (x, y, tool) = cur
    for new_tool in range(3):
        if tool != new_tool:
            yield ((x, y, new_tool), 7)
    for (nx, ny) in [(x-1, y), (x+1, y), (x, y+1), (x, y-1)]:
        if nx >= 0 and nx < tx+100 and ny >= 0 and ny < ty+100:
            if tool != e_level(grid[nx][ny]) % 3:
                yield ((nx, ny, tool), 1)

print(dijkstra_visited(
    origin=(0,0,1),
    nextsteps=next_steps,
    done=lambda x: x == (tx, ty, 1)))
