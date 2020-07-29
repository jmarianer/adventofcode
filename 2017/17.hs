rotate :: Int -> [a] -> [a]
rotate i xs = back ++ front
  where (front, back) = splitAt i xs

move skip list num = (:) num $! (rotate (skip `mod` length list) list) 

skip = 356
main = do
  let final = foldl (move (skip + 1)) [0] [1..2017]
  print $ final !! 1
