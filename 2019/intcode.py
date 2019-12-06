def runprog(prog, n, v):
    prog = list(prog)
    prog[1] = n
    prog[2] = v
    cur = 0
    while prog[cur] != 99:
        x = prog[prog[cur+1]]
        y = prog[prog[cur+2]]
        op = prog[cur]
        out = x+y if op == 1 else x*y
        prog[prog[cur+3]] = out
        cur += 4

    return prog[0]

