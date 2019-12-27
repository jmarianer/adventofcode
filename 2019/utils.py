from queue import Queue

def queue_iterator(q):
    while not q.empty():
        yield q.get()

def nextsteps2d(point):
    x, y = point
    return [(x, y+1),
            (x, y-1),
            (x+1, y),
            (x-1, y)]

def basic_bfs(origin, should_visit, nextsteps, visit, destination=None):
    queue = Queue()
    queue.put((origin, 0))

    for point, distance in queue_iterator(queue):
        if not should_visit(point):
            continue

        visit(point, distance)
        if point == destination:
            return distance
        
        for ns in nextsteps(point):
            queue.put((ns, distance + 1))

    return None


def bfs_visited(origin, nextsteps, destination, should_visit):
    visited = set()
    should_visit1 = lambda point: point not in visited and should_visit(point)
    visit = lambda point, _: visited.add(point)

    return basic_bfs(
            origin=origin,
            should_visit=should_visit1,
            nextsteps=nextsteps,
            visit=visit,
            destination=destination)
