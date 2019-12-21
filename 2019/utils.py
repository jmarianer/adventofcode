def queue_iterator(q):
    while True:
        yield q.get()
