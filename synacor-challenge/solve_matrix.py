from queue import Queue
import more_itertools

matrix = [
        ['*',   8, '-',   1],
        [  4, '*',  11, '*'],
        ['+',   4, '-',  18],
        [ 22, '-',   9, '*']]

def queue_iterator(q):
    while not q.empty():
        yield q.get()

queue = Queue()
queue.put((3, 0, [], ''))

for i, j, exp, path in queue_iterator(queue):
    cur = matrix[i][j]
    if (i, j) == (3, 0) and path != '':
        continue

    exp = exp.copy() + [cur]
    if isinstance(cur, int):
        res = exp[0]
        for (op, num) in more_itertools.chunked(exp[1:], 2):
            if op == '+':
                res += num
            elif op == '-':
                res -= num
            elif op == '*':
                res *= num
        if (i, j, res) == (0, 3, 30):
            print(i, j, exp, res, path)
    if i > 0:
        queue.put((i-1, j, exp, path + 'n'))
    if i < 3:
        queue.put((i+1, j, exp, path + 's'))
    if j > 0:
        queue.put((i, j-1, exp, path + 'w'))
    if j < 3:
        queue.put((i, j+1, exp, path + 'e'))
