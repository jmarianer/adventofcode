import Data.List
import Util

mostCommon :: [Char] -> Char
mostCommon = head . last . sortWith length . group . sort

leastCommon :: [Char] -> Char
leastCommon = head . head . sortWith length . group . sort

main = do
  c <- getContents
  print $ map mostCommon $ transpose $ lines c
  print $ map leastCommon $ transpose $ lines c
