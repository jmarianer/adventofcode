from queue import Queue, PriorityQueue

def queue_iterator(q):
    while not q.empty():
        yield q.get()

def nextsteps2d(point):
    x, y = point
    return [(x, y+1),
            (x, y-1),
            (x+1, y),
            (x-1, y)]

# TODO: basic_bfs should be written in terms of basic_dijkstra
def basic_bfs(origin, should_visit, nextsteps, visit, done=lambda _: False):
    queue = Queue()
    queue.put((0, origin))

    for distance, point in queue_iterator(queue):
        if not should_visit(point):
            continue

        visit(point, distance)
        if done(point):
            return distance
        
        for ns in nextsteps(point):
            queue.put((distance + 1, ns))

    return None


def basic_dijkstra(origin, should_visit, nextsteps, visit, done=lambda _: False):
    queue = PriorityQueue()
    queue.put((0, origin))

    for total_distance, point in queue_iterator(queue):
        if not should_visit(point):
            continue

        visit(point, total_distance)
        if done(point):
            return total_distance
        
        for ns, distance in nextsteps(point):
            queue.put((total_distance + distance, ns))

    return None


def bfs_visited(
        origin,
        nextsteps,
        should_visit,
        destination=None,
        distill_for_visited=lambda x: x,
        visit=lambda _1, _2: None):
    visited = set()
    should_visit1 = lambda point: distill_for_visited(point) not in visited and should_visit(point)
    visit1 = lambda point, distance: (visited.add(distill_for_visited(point)), visit(point, distance))

    return basic_bfs(
            origin=origin,
            should_visit=should_visit1,
            nextsteps=nextsteps,
            visit=visit1,
            done=lambda x: x == destination)


def dijkstra_visited(
        origin,
        nextsteps,
        should_visit=lambda _: True,
        done=lambda _: False,
        distill_for_visited=lambda x: x,
        visit=lambda _1, _2: None):
    visited = set()
    should_visit1 = lambda point: distill_for_visited(point) not in visited and should_visit(point)
    visit1 = lambda point, distance: (visited.add(distill_for_visited(point)), visit(point, distance))

    return basic_dijkstra(
            origin=origin,
            should_visit=should_visit1,
            nextsteps=nextsteps,
            visit=visit1,
            done=done)
