import Data.Bits
import Data.List
import Data.Maybe
import Data.Matrix as Matrix

import Knothash

byteToBits :: Int -> [Int]
byteToBits a = [a `shiftR` i .&. 1 | i <- [7,6..0]]

floodfill :: Int -> (Int, Int) -> Matrix Int -> Matrix Int
floodfill n (i, j) matrix =
  if safeGet i j matrix == Just 1
  then floodfill n (i+1, j) $
       floodfill n (i-1, j) $
       floodfill n (i, j-1) $
       floodfill n (i, j+1) $
       setElem n (i, j) matrix
  else matrix

whereIs :: (Eq a) => a -> Matrix a -> Maybe (Int, Int)
whereIs a matrix = listToMaybe [(i, j) | i <- [1..nrows matrix], j <- [1..ncols matrix], getElem i j matrix == a]

grouper n matrix =
  case firstOne of Nothing -> n - 2
                   Just (i, j) -> grouper (n+1) $ floodfill n (i, j) matrix
  where firstOne = whereIs 1 matrix

-- Test key = "flqrgnkx"
key = "xlqgujun"

main = do
  let allBytes = map (\n -> hashToList (key ++ "-" ++ (show n))) [0..127]
  --print $ foldl (+) 0 $ map popCount $ concat allBytes

  --putStrLn $ concat $ intersperse "\n" $ map (\l -> show $ byteToBits $ head l) allBytes
  let matrix = Matrix.fromLists $ map (\l -> concat $ map byteToBits l) allBytes
  let smallMatrix = setSize 0 8 8 matrix
  print smallMatrix
  print $ grouper 2 matrix
