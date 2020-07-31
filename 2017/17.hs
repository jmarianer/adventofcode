rotate :: Int -> [a] -> [a]
rotate i xs = back ++ front
  where (front, back) = splitAt i xs

move skip list num = (:) num $! (rotate (skip `mod` length list) list) 

skip = 356
main = do
  let final = foldl (move (skip + 1)) [0] [1..2017]
  print $ final !! 1

  let positions = scanl (\n k -> (n+skip) `mod` k + 1) 0 [1..50000000]
  print $ last $ filter (\(i, n) -> n == 1) $ [0..] `zip` positions
