halve xs = (take h xs, drop h xs)
  where
  h = length xs `div` 2

pairs1 s = (s `zip` (tail s ++ [head s]))
pairs2 s = (h1 `zip` h2) where (h1, h2) = halve s
identicalNums s =
  map (\(x,y) -> read [x] :: Int)
  (filter (\(x,y) -> x==y) s)

main = do
  s <- getLine
  print (sum (identicalNums (pairs1 s)))
  print (sum (identicalNums (pairs2 s)) * 2)
