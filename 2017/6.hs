import qualified Data.Map as Map
import Data.List
import Data.List.Tools
import Data.Maybe

n `x` k = take k (repeat n)
rotate :: Int -> [a] -> [a]
rotate i xs = back ++ front
  where (front, back) = splitAt i xs

next :: [Int] -> [Int]
next list = zipWith (+) (setAt list index 0) adds'
  where max :: Int
        max = maximum list
        index = fromMaybe 0 $ elemIndex max list
        len = length list
        add = max `div` len
        extraCount = max - (add * len)
        adds = (add + 1) `x` extraCount ++ add `x` (len - extraCount)
        adds' = rotate (len - index - 1) adds

firstRepetition list = fr' Map.empty list 0
  where fr' map list acc =
          case Map.lookup list map of
            Nothing -> fr' (Map.insert list acc map) (next list) (acc+1)
            Just x  -> (acc, acc - x)

main = do
  c <- getContents
  let initial = map (read :: String -> Int) $ words c
  print initial
  print $ next initial
  print $ next $ next initial
  print $ next $ next $ next initial
  print $ next $ next $ next $ next initial
  print $ firstRepetition initial
