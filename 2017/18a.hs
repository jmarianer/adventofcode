f n = (n*8505*129749 + 12345) `mod` (2^31-1)

main = do
  print $ last $ map ((flip mod) 10000) $ take 128 $ iterate f 680
