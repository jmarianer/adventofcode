import Data.List
import Data.List.Split

parseLine :: String -> (Int, Int)
parseLine s = (read a, read b)
  where [a, b] = splitOn "-" s

firstAvailable :: Int -> [(Int, Int)] -> Int
firstAvailable oldFirst [] = oldFirst
firstAvailable oldFirst ((s, e):xs) =
  if s > oldFirst
  then oldFirst
  else firstAvailable newFirst xs
  where newFirst = max oldFirst (e+1)

allAvailable :: Int -> [(Int, Int)] -> [Int]
allAvailable oldFirst [] = [oldFirst..2^31]
allAvailable oldFirst ((s, e):xs) =
  [oldFirst..(s-1)] ++ allAvailable newFirst xs
  where newFirst = max oldFirst (e+1)

main = do
  c <- getContents
  let sorted = sort $ map parseLine $ lines c
  print $ firstAvailable 0 sorted
  print $ length $ allAvailable 0 sorted
