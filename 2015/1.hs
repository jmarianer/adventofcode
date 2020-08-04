{-
 - I originally solved this in VI using the % key a lot, but this way is a bit more general. :-)
 -}

import Util

finalFloor :: String -> Int
finalFloor s = count (=='(') s - count (==')') s

firstBasement :: String -> Int
firstBasement = fb' 0 0
  where fb' floor count ('(':xs) = fb' (floor+1) (count+1) xs
        fb' (-1)  count _        = count
        fb' floor count (')':xs) = fb' (floor-1) (count+1) xs

main = do
  c <- getContents
  print $ finalFloor c
  print $ firstBasement c
