from intcode import Prog
import itertools, more_itertools, time
import numpy as np

prog = [109, 424, 203, 1, 21102, 11, 1, 0, 1105, 1, 282, 21101, 18, 0, 0, 1106,
        0, 259, 2101, 0, 1, 221, 203, 1, 21101, 0, 31, 0, 1105, 1, 282, 21101,
        0, 38, 0, 1106, 0, 259, 21001, 23, 0, 2, 21202, 1, 1, 3, 21102, 1, 1,
        1, 21102, 57, 1, 0, 1105, 1, 303, 2101, 0, 1, 222, 21002, 221, 1, 3,
        20101, 0, 221, 2, 21101, 259, 0, 1, 21101, 0, 80, 0, 1105, 1, 225,
        21102, 198, 1, 2, 21102, 91, 1, 0, 1106, 0, 303, 1201, 1, 0, 223,
        21002, 222, 1, 4, 21101, 0, 259, 3, 21102, 225, 1, 2, 21102, 225, 1, 1,
        21102, 1, 118, 0, 1106, 0, 225, 21001, 222, 0, 3, 21101, 0, 140, 2,
        21101, 133, 0, 0, 1106, 0, 303, 21202, 1, -1, 1, 22001, 223, 1, 1,
        21102, 1, 148, 0, 1106, 0, 259, 2101, 0, 1, 223, 21002, 221, 1, 4,
        21002, 222, 1, 3, 21101, 0, 24, 2, 1001, 132, -2, 224, 1002, 224, 2,
        224, 1001, 224, 3, 224, 1002, 132, -1, 132, 1, 224, 132, 224, 21001,
        224, 1, 1, 21102, 1, 195, 0, 106, 0, 108, 20207, 1, 223, 2, 21001, 23,
        0, 1, 21102, 1, -1, 3, 21102, 1, 214, 0, 1106, 0, 303, 22101, 1, 1, 1,
        204, 1, 99, 0, 0, 0, 0, 109, 5, 1201, -4, 0, 249, 21202, -3, 1, 1,
        22101, 0, -2, 2, 21202, -1, 1, 3, 21102, 1, 250, 0, 1105, 1, 225,
        22101, 0, 1, -4, 109, -5, 2106, 0, 0, 109, 3, 22107, 0, -2, -1, 21202,
        -1, 2, -1, 21201, -1, -1, -1, 22202, -1, -2, -2, 109, -3, 2106, 0, 0,
        109, 3, 21207, -2, 0, -1, 1206, -1, 294, 104, 0, 99, 22101, 0, -2, -2,
        109, -3, 2105, 1, 0, 109, 5, 22207, -3, -4, -1, 1206, -1, 346, 22201,
        -4, -3, -4, 21202, -3, -1, -1, 22201, -4, -1, 2, 21202, 2, -1, -1,
        22201, -4, -1, 1, 22102, 1, -2, 3, 21101, 0, 343, 0, 1105, 1, 303,
        1106, 0, 415, 22207, -2, -3, -1, 1206, -1, 387, 22201, -3, -2, -3,
        21202, -2, -1, -1, 22201, -3, -1, 3, 21202, 3, -1, -1, 22201, -3, -1,
        2, 22101, 0, -4, 1, 21102, 1, 384, 0, 1105, 1, 303, 1106, 0, 415,
        21202, -4, -1, -4, 22201, -4, -3, -4, 22202, -3, -2, -2, 22202, -2, -4,
        -4, 22202, -3, -2, -3, 21202, -4, -1, -2, 22201, -3, -2, 1, 21201, 1,
        0, -4, 109, -5, 2105, 1, 0]

def get_stat(i, j):
    return more_itertools.first(Prog(prog).run(iter([i, j])))

SIZE=50

#tot = 0
#for i in range(SIZE):
#    for j in range(SIZE):
#        out = get_stat(i, j)
#        if out == 1:
#            tot += 1
#            print('#', end='')
#        else:
#            print('.', end='')
#
#    print()
#
#print(tot)

# Part II
current = (50, 50)
field_desc = {}
MAX_I = 5000
# 550 below = trial and error, a value of i that is known to be a row that is too narrow.
for i in range(550, MAX_I):
    for j in itertools.count(current[0]):
        if get_stat(i, j) == 1:
            start = j
            break
    for j in itertools.count(start + current[1] - current[0]):
        if get_stat(i, j) == 0:
            end = j
            break
    current = (start, end)
    field_desc[i] = current

for i in range(550, MAX_I):
    square_start = max(field_desc[i1][0] for i1 in range(i, i+100))
    square_end = min(field_desc[i1][1] for i1 in range(i, i+100))
    if square_end - square_start >= 100:
        print(i, square_start)
        break
