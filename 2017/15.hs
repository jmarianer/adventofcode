gen start mult = tail g'
  where g' = start : (map (\n -> n * mult `mod` 2147483647) g')

judge (x, y) = (x `mod` 65536) == (y `mod` 65536)

count :: [Bool] -> Int
count xs = count' xs 0
  where count' (True:xs)  acc = count' xs $! acc + 1
        count' (False:xs) acc = count' xs $! acc
        count' []         acc = acc

onlyMult k = filter (\n -> n `mod` k == 0)

-- Test input:
--genA = gen 65 16807
--genB = gen 8921 48271
genA = gen 783 16807
genB = gen 325 48271
main = do
  --print $ count $ take 40000000 $ map judge $ zip genA genB
  print $ count $ take 5000000 $ map judge $ zip (onlyMult 4 genA) (onlyMult 8 genB)
