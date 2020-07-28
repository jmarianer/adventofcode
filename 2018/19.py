"""
The program first jumps to a subroutine to initialize r4, then comes
back and executes the following:
 1 seti 1 1 1    r1 = 1
 2 seti 1 4 3    r3 = 1
 3 mulr 1 3 5    r5 = r1 * r3
 4 eqrr 5 4 5    if r5 == r4:
 5 addr 5 2 2     
 6 addi 2 1 2    
 7 addr 1 0 0      r0 += r1
 8 addi 3 1 3    r3++
 9 gtrr 3 4 5    if r3 <= r4:
10 addr 2 5 2     
11 seti 2 4 2      goto 3
12 addi 1 1 1    r1++
13 gtrr 1 4 5    if r1 > r4:
14 addr 5 2 2      skip next
15 seti 1 0 2    goto 3
16 mulr 2 2 2    r2 *= r2 (i.e., halt)

This bit of code simply calculates the sum of all the factors of r4,
including itself. We can do that in Python much faster than this could
hope to be (for one thing, we have division!).
"""


part1num = 875
part2num = 10551275

def facs(num):
    for i in range(1, num+1):
        if num % i == 0:
            yield i

print(sum(facs(part1num)))
print(sum(facs(part2num)))
