def queue_iterator(q):
    while not q.empty():
        yield q.get()
