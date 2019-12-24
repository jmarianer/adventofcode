import itertools, more_itertools
from functools import lru_cache

inpt = '59762574510031092870627555978901048140761858379740610694074091049186715780458779281173757827279664853239780029412670100985236587608814782710381775353184676765362101185238452198186925468994552552398595814359309282056989047272499461615390684945613327635342384979527937787179298170470398889777345335944061895986118963644324482739546009761011573063020753536341827987918039441655270976866933694280743472164322345885084587955296513566305016045735446107160972309130456411097870723829697443958231034895802811058095753929607703384342912790841710546106752652278155618050157828313372657706962936077252259769356590996872429312866133190813912508915591107648889331'
inpt = list(int(i) for i in inpt)

@lru_cache(maxsize = None)
def positive(digitno):
    positive = [
            4 * (digitno + 1) * i + j
            for i in range(len(inpt) // (4 * (digitno + 1)) + 1)
            for j in range(digitno, digitno*2 + 1)]
    return [i for i in positive if i < len(inpt)]

@lru_cache(maxsize = None)
def negative(digitno):
    negative = [i + (digitno + 1) * 2 for i in positive(digitno)]
    return [i for i in negative if i < len(inpt)]

    if digitno % 100 == 0:
        print(digitno, positive[digitno])


@lru_cache(maxsize = None)
def calc_digit(stepno, digitno):
    if digitno >= len(inpt):
        return 0

    if stepno == 0:
        return inpt[digitno]

    my_sum = sum(calc_digit(stepno - 1, i) for i in positive(digitno))
    my_sum -= sum(calc_digit(stepno - 1, i) for i in negative(digitno))

    return abs(my_sum) % 10

# Part I
print(''.join(str(calc_digit(100, i)) for i in range(8)))


# Part II
# I finally realized (thanks to Reddit, not on my own :-() that this only needs
# to work for large indexes; indexes so large that the pattern is just
# 0000...111. Therefore we only need to calculate the cumulative sum from
# position N to the end.
start = int(''.join(str(inpt[i]) for i in range(7)))
cur = inpt * 10000
cur = cur[start:]
for step in range(100):
    for i in reversed(range(len(cur) - 1)):
        #cur[i] = (cur[i] + cur[i+1]) % 10
        cur[i] = cur[i] + cur[i+1]

print(''.join(str(cur[i] % 10) for i in range(8)))
