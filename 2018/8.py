license = (int(i) for i in input().split(' '))

def read_node():
    child_count = next(license)
    meta_count = next(license)
    children = []
    meta = []
    for _ in range(child_count):
        children.append(read_node())
    for _ in range(meta_count):
        meta.append(next(license))
    return (children, meta)

node = read_node()

def meta_total(node):
    children, meta = node
    return sum(meta_total(child) for child in children) + sum(meta)

print(meta_total(node))

def node_value(node):
    children, meta = node

    if len(children) == 0:
        return sum(meta)
    else:
        return sum(node_value(children[m - 1]) for m in meta if m > 0 and m <= len(children))

print(node_value(node))
