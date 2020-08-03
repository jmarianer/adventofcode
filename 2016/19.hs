{-
 - This program was only written to get a sense for the formulas. By printing
 - out the first 200 values, I was able to guess that the formula for part I is
 - 2(n-k)+1, where k is the highest power of 2 less than n.
 - The formula for part II is n-k if n<2k and 2n-k if n>2k, where k is the
 - highest power of 3 less than n.
 -}

import Data.List.Split

step1 [] = []
step1 (a:[]) = [a]
step1 (a:b:rest) = rest ++ [a]

lastElf1 n = head $ (!!n)$ iterate step1 [1..n]

step2 :: [Int] -> [Int]
step2 [] = []
step2 (a:[]) = [a]
step2 (a:xs) = s1 ++ s2 ++ [a]
  where (s1, (_:s2)) = splitAt ((length xs - 1) `div` 2) xs

lastElf2 n = head $ (!!n)$ iterate step2 [1..n]

main = do
  print $ map (\n -> (n, lastElf1 n)) [1..200]
  print $ map (\n -> (n, lastElf2 n)) [1..200]

  -- Answers to both parts where the input is 3005290:
  print $ (3005290 - 2097152) * 2 + 1
  print $ 3005290 - 3^13
