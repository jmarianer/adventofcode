import sys

prog = sys.stdin.readlines()
regs = [0] * 6
ip_line = prog.pop(0)
ip_reg = int(ip_line.split(' ')[1])

while True:
    if regs[ip_reg] >= len(prog):
        break

    cur_line = prog[regs[ip_reg]]
    opcode, a, b, c = cur_line.split(' ')
    a = int(a)
    b = int(b)
    c = int(c)

    if opcode == 'addr':
        regs[c] = regs[a] + regs[b]
    elif opcode == 'addi':
        regs[c] = regs[a] + b

    elif opcode == 'mulr':
        regs[c] = regs[a] * regs[b]
    elif opcode == 'muli':
        regs[c] = regs[a] * b

    elif opcode == 'banr':
        regs[c] = regs[a] & regs[b]
    elif opcode == 'bani':
        regs[c] = regs[a] & b

    elif opcode == 'borr':
        regs[c] = regs[a] | regs[b]
    elif opcode == 'bori':
        regs[c] = regs[a] | b

    elif opcode == 'setr':
        regs[c] = regs[a]
    elif opcode == 'seti':
        regs[c] = a

    elif opcode == 'gtir':
        regs[c] = 1 if a > regs[b] else 0
    elif opcode == 'gtri':
        regs[c] = 1 if regs[a] > b else 0
    elif opcode == 'gtrr':
        regs[c] = 1 if regs[a] > regs[b] else 0

    elif opcode == 'eqir':
        regs[c] = 1 if a == regs[b] else 0
    elif opcode == 'eqri':
        regs[c] = 1 if regs[a] == b else 0
    elif opcode == 'eqrr':
        regs[c] = 1 if regs[a] == regs[b] else 0

    print(regs)
    regs[ip_reg] += 1

print(regs[0])
