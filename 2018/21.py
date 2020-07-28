"""
After testing the bitwise operator, the program runs as follows:
 5 seti 0 8 4           r4 = 0
 6 bori 4 65536 3       r3 = r4 | 65536
 7 seti 14464005 5 4    r4 = 14464005
 8 bani 3 255 2         r2 = r3 & 255
 9 addr 4 2 4           r4 += r2
10 bani 4 16777215 4    r4 &= 2^24-1
11 muli 4 65899 4       r4 *= 65899
12 bani 4 16777215 4    r4 &= 2^24-1
13 gtir 256 3 2         if r3 < 256:
14 addr 2 5 5            
15 addi 5 1 5           
16 seti 27 7 5            goto 28
17 seti 0 3 2           r2 = 0        IOW r3 /= 256
18 addi 2 1 1           r1 = r2 + 1       r2 = r3
19 muli 1 256 1         r1 *= 256         goto 8
20 gtrr 1 3 1           if r1 > r3:
21 addr 1 5 5
22 addi 5 1 5
23 seti 25 2 5            goto 26
24 addi 2 1 2           r2++
25 seti 17 9 5          goto 18
26 setr 2 2 3           r3 = r2
27 seti 7 3 5           goto 8
28 eqrr 4 0 2           if r4 == r0:
29 addr 2 5 5             halt
30 seti 5 9 5           goto 6

The loop at lines 17–25 divides r3 by 256. The loop at lines 8–27
calculates a certain value based on the individual bytes of r3. The
entire program is a loop that calculates a value in r4 based on the
previous value of r4 (with an initial value of 0) and stops if that
value is equal to r0 (which is never modified over the course of this
program).

The following loop calculates the same values of r4 (here called a).
The program which stops as quickly as possible is the first value
printed below.

To run for as long as possible, we notice that the values loop after a
while; we want the last value before the loop, which is the
next-to-last value printed below.
"""

b = 65536

seen = set()
while True:
    a = 14464005
    while b > 0:
        b1 = b & 0xff
        b >>= 8

        a += b1
        a *= 65899
        a &= 16777215
    print(a)

    if a in seen:
        break
    seen.add(a)
    b = a | 65536
