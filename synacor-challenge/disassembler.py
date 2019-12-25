import struct, sys, itertools
from interpreter import AsciiProg

# TODO: Share this with the main solution
with open('challenge.bin', mode='rb') as f:
    fileContent = f.read()

fmt = "<%dH" % (len(fileContent) / 2)
code = struct.unpack(fmt, fileContent)

# TODO: reuse this here and in the interpreter.
param_count = [
        0, 2, 1, 1, 3, 3, 1, 2, 2, 3,  # 0 – 9
        3, 3, 3, 3, 2, 2, 2, 1, 0, 1,  # 10 – 10
        1, 0]                          # 20 – 21
opcodes = [
        'halt', 'set', 'push', 'pop', 'eq',
        'gt', 'jmp', 'jt', 'jf', 'add',
        'mult', 'mod', 'and', 'or', 'not',
        'rmem', 'wmem', 'call', 'ret', 'out',
        'in', 'noop']

def stringify(param):
    if param <= 32767:
        return str(param)
    else:
        return 'r' + str(param - 32768)

i = 0
while i < len(code):
    op = code[i]
    if op >= len(param_count):
        i += 1
        continue
    params = code[i+1:i+param_count[op]+1]
    params = ', '.join(stringify(param) for param in params)
    print("%d: %s %s" % (i, opcodes[op], params))
    i += param_count[op] + 1
