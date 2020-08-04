import Site

import Data.List

dirs :: String -> [Direction]
dirs = map dir
  where dir '<' = Lt
        dir '>' = Rt
        dir '^' = Up
        dir 'v' = Dn

outerleave :: [a] -> ([a], [a])
outerleave l = o' ([], []) $ reverse l
  where o' (acc1, acc2) (a:b:xs) = o' (a:acc1, b:acc2) xs
        o' (acc1, acc2) [a]      = (a:acc1, acc2)
        o' accs         []       = accs

--houses :: [Direction] -> 
houses = scanl (flip move) (0, 0)

main = do
  c <- getContents
  let allDirs = dirs $ init c

  print $ length $ nub $ houses allDirs   

  let (santa, robot) = outerleave allDirs
  print $ length $ nub (houses santa ++ houses robot)
