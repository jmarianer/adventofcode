def getparam(prog, cur, paramno):
    param_mode = prog[cur] // (10**(paramno+1)) % 10
    param = prog[cur + paramno]
    return param if param_mode == 1 else prog[param]

def runprog(prog, n=None, v=None, inpt=iter([])):
    output = []

    prog = list(prog)
    if v is not None:
        prog[1] = n
        prog[2] = v
    cur = 0
    while prog[cur] != 99:
        op = prog[cur] % 100
        if op == 1:
            prog[prog[cur+3]] = getparam(prog, cur, 1) + getparam(prog, cur, 2)
            cur += 4
        elif op == 2:
            prog[prog[cur+3]] = getparam(prog, cur, 1) * getparam(prog, cur, 2)
            cur += 4
        elif op == 3:
            prog[prog[cur+1]] = next(inpt)
            cur += 2
        elif op == 4:
            output.append(getparam(prog, cur, 1))
            cur += 2
        elif op == 5:
            if getparam(prog, cur, 1) != 0:
                cur = getparam(prog, cur, 2)
            else:
                cur += 3
        elif op == 6:
            if getparam(prog, cur, 1) == 0:
                cur = getparam(prog, cur, 2)
            else:
                cur += 3
        elif op == 7:
            prog[prog[cur+3]] = 1 if getparam(prog, cur, 1) < getparam(prog, cur, 2) else 0
            cur += 4
        elif op == 8:
            prog[prog[cur+3]] = 1 if getparam(prog, cur, 1) == getparam(prog, cur, 2) else 0
            cur += 4


    return prog[0], output

if __name__ == "__main__":
    prog = [int(i) for i in input().split(',')]
    print(runprog(prog))
