maxList (x:xs) = foldl max x xs
minList (x:xs) = foldl min x xs

lineDivisors x = [i `div` j | i <- x, j <- x, i `mod` j == 0, i /= j]

main = do
  c <- getContents
  let matrix = map (map read . words) $ lines c :: [[Int]]
  let lineSums = map (\line -> maxList line - minList line) matrix
  print $ sum lineSums

  --let lineDivisors = map lineDivisors matrix
  print $ sum [i | div <- map lineDivisors matrix, i <- div]
