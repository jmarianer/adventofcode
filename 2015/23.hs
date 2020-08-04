import Data.List

{-
 - This is the contents of the program:
 - jio a, +22   if a = 1 then skip this part
 - inc a        a = 1
 - tpl a        3
 - tpl a        9
 - tpl a        27
 - inc a        28
 - tpl a        84
 - inc a        85
 - tpl a        255
 - inc a
 - inc a        257
 - tpl a        771
 - inc a
 - inc a        773
 - tpl a        2319
 - inc a
 - inc a        2321
 - tpl a        6963
 - inc a
 - inc a        6965
 - tpl a        20895
 - jmp +19      goto A
 - tpl a     B: 3
 - tpl a        9
 - tpl a        27
 - tpl a        81
 - inc a
 - inc a        83
 - tpl a        249
 - inc a        350
 - tpl a        750
 - inc a
 - inc a        752
 - tpl a        2256
 - inc a
 - inc a        2258
 - tpl a        6774
 - inc a        6775
 - tpl a
 - tpl a        60975
 - jio a, +8 A: until a=1:
 - inc b        b++
 - jie a, +4    if a odd
 - tpl a          then triple a + 1
 - inc a
 - jmp +2
 - hlf a          else half a
 - jmp -7       end until
 -
 - In other words, it first calculates some initial value which is 20895 if a=0
 - or 60975 if a=1, and then does the famous "triple-plus-one-or-half" sequence
 - and counts the steps. That's it.
 -}

step a = if even a then a `div` 2 else 3*a + 1

main = do
  print $ elemIndex 1 $ iterate step 20895
  print $ elemIndex 1 $ iterate step 60975
