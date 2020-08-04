las :: String -> String
las [] = []
las (a:as) = (show $ length first) ++ [a] ++ (las second)
  where (first, second) = span (==a) (a:as)

main = do
  print $ length $ (iterate las "1113122113") !! 40
  print $ length $ (iterate las "1113122113") !! 50
