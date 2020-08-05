import Util

countCombos :: Int -> [Int] -> Int
countCombos 0 _      = 1
countCombos _ []     = 0
countCombos n (x:xs) = countCombos n xs + countCombos (n-x) xs

combos :: Int -> [Int] -> [[Int]]
combos 0 _      = [[]]
combos _ []     = []
combos n (x:xs) = combos n xs ++ (map (x:) $ combos (n-x) xs)

main = do
  c <- getContents
  let l = map (read :: String -> Int) $ lines c
  print $ countCombos 150 l

  let comboLengths = map length $ combos 150 l
      minCombo = minimum comboLengths
  print $ count (== minCombo) comboLengths
