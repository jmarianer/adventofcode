f n = (n*8505*129749 + 12345) `mod` (2^31-1)

main = do
  print $ length $ takeWhile (>0) $ map ((flip mod) 10000) $ iterate f 680
