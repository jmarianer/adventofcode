from functools import lru_cache

@lru_cache(maxsize = None)
def my_routine(r0, r1, r7):
    # This is pretty much a direct translation of the disassembly
    #print(r1)
    if r0 == 0:
        return r1 + 1

    elif r1 == 0:
        return my_routine(r0-1, r7, r7)

    else:
        r1 = my_routine(r0, r1-1, r7)
        return my_routine(r0-1, r1, r7)


@lru_cache(maxsize = None)
def my_routine2(r0, r1, r7):
    while r0 > 0:
        if r1 == 0:
            r1 = r7
        else:
            r1 = my_routine2(r0, r1-1, r7) % 32768
        r0 -= 1

    return r1 + 1



r0 = 4
r1 = 0
for r7 in range(32768):
    #print(my_routine(r0, r1, r7))
    #print(my_routine2(r0, r1, r7))
    #print(r7, my_routine2(3,1,r7))
    #print("  ", my_routine(r0, r1, r7+1) - my_routine(r0, r1, r7))
    f0 = list(range(1, 32768)) + [0]
    f1 = [f0[r7]]
    for i in range(1, 32768):
        r1 = f1[-1]
        f1.append(f0[r1])
    f2 = [f1[r7]]
    for i in range(1, 32768):
        r1 = f2[-1]
        f2.append(f1[r1])
    f3 = [f2[r7]]
    for i in range(1, 32768):
        r1 = f3[-1]
        f3.append(f2[r1])
    f4 = [f3[r7]]
    for i in range(1, 32768):
        r1 = f4[-1]
        f4.append(f3[r1])
    if f4[1] == 6:
        print(r7, "!!!")
    if r7 % 1000 == 0:
        print(r7)
    
