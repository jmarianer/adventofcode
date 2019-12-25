import struct, sys, itertools
from interpreter import AsciiProg

with open('/Users/joeym/Downloads/synacor-challenge (1)/challenge.bin', mode='rb') as f:
    fileContent = f.read()

fmt = "<%dH" % (len(fileContent) / 2)
code = list(struct.unpack(fmt, fileContent))

# Hack at teleporter
code[5485] = 6
code[5489] = 21
code[5490] = 21


prog = AsciiProg(code)

save = []

initialize = """
take tablet
doorway
north
north
bridge
continue
down
east
take empty lantern
west
west
passage
ladder
west
south
north
take can
look can
use can
use lantern
west
ladder
darkness
continue
west
west
west
west
north
take red coin
north
east
take concave coin
down
take corroded coin
up
west
west
take blue coin
up
take shiny coin
down
east
use blue coin
use red coin
use shiny coin
use concave coin
use corroded coin
north
take teleporter
use teleporter
"""

beach = """
use teleporter
north
north
north
north
north
north
north
east
take journal
west
north
north
take orb
north
east
east
north
west
south
east
east
west
north
north
east
vault
take mirror
use mirror
"""

def inpt():
    for line in initialize:
        yield line
    prog.regs[7] = 25734
    for line in beach:
        yield line

    for line in sys.stdin:
        save.append(line.rstrip())
        yield line

for outline in AsciiProg(prog).run(inpt()):
    print(outline)

for line in save:
    print(line)


