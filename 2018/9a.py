ELVES = 471
MAX = 72026

from llist import dllist
circle = dllist([0])
current = circle.first

scores = [0]  * ELVES

def prev():
    global current
    current = current.prev
    if current is None:
        current = circle.last

def next():
    global current
    current = current.next
    if current is None:
        current = circle.first


def show():
    global current
    for i in circle:
        if i == current.value:
            print(f'({i})', end=' ')
        else:
            print(i, end=' ')
    print()


def insert_marble(marble):
    global current, scores
    if marble % 23 == 0:
        prev()
        prev()
        prev()
        prev()
        prev()
        prev()
        prev()
        scores[marble % ELVES] += marble + current.value
        old = current
        next()
        circle.remove(old)
    else:
        next()
        current = circle.insert(marble, current.next)
    

for marble in range(1, MAX+1):
    insert_marble(marble)
print(marble, max(scores))

for marble in range(MAX+1, MAX*100+1):
    insert_marble(marble)
print(marble, max(scores))
