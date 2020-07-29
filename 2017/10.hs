import Data.Char
import Data.List.Split
import Data.Bits (xor)
import Numeric (showHex)


rotate :: Int -> [a] -> [a]
rotate i xs = back ++ front
  where (front, back) = splitAt i xs

doStep :: ([Int], Int, Int) -> Int -> ([Int], Int, Int)
doStep (list, cur, skip) len = (newList, newCur, skip + 1)
  where newCur = (cur + len + skip) `mod` (length list)
        rotatedList = rotate cur list
        reverseLen = (reverse front) ++ back
          where (front, back) = splitAt len rotatedList
        newList = rotate (length list - cur) reverseLen

lengths = [230,1,2,221,97,252,168,169,57,99,0,254,181,255,235,167]
input = "230,1,2,221,97,252,168,169,57,99,0,254,181,255,235,167"
initial =  ([0..255], 0, 0)

showHex' n str = if n < 16
                 then '0':(showHex n str)
                 else (showHex n str)

hashString str = foldl (flip showHex') "" (reverse xors)
  where lengths = (map ord str) ++ [17, 31, 73, 47, 23]
        (finalList, _, _) = foldl doStep initial (concat $ replicate 64 lengths)
        xors = map (foldl xor 0) $ chunksOf 16 finalList

main = do
  let (finalList, _, _) = foldl doStep initial lengths
  let (x:y:_) = finalList
  print (x*y)

  print $ hashString input
