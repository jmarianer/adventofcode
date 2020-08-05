{-
set b 57
set c b
jnz a 2        goto C in debug mode
jnz 1 5
mul b 100      b = 105700
sub b -100000
set c b
sub c -17000   c = 122700
set f 1     C: f=1, d=2
set d 2
set e 2     B: e=2
set g d     A: 
mul g e        
sub g b
jnz g 2        if de-b == 0 then f=0
set f 0
sub e -1       e++
set g e        
sub g b
jnz g -8       if e == b then goto A
sub d -1       d++
set g d        if d == b then goto B
sub g b
jnz g -13
jnz f 2        if f == 0 then h++
sub h -1
set g b        if b == c then exit
sub g c
jnz g 2
jnz 1 3
sub b -17      b += 17
jnz 1 -23      goto C


IOW b : 105700 -> 122700 in steps of 17
    d : 2 -> b
    e : 2 -> b
    h++ if at any point in those loops, de == b
    IOW, count the composite numbers between (inclusive) those two endpoints
 -}
import Primes

main = do
  print $ length $ filter (not . isPrime) [105700,105717..122700]
