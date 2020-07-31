import Data.Set (Set)
import qualified Data.Set as Set

read2 :: (String, String) -> (Int, Int)
read2 (s, t) = (read s, read $ tail t)

getPairs1 :: Set (Int, Int) -> Int -> [(Int, Int)]
getPairs1 set i = Set.toList $ Set.filter (\(i', _) -> i == i') set
getPairs2 :: Set (Int, Int) -> Int -> [(Int, Int)]
getPairs2 set j = Set.toList $ Set.filter (\(_, j') -> j == j') set

otherSide1 :: Set (Int, Int) -> Int -> [(Set (Int, Int), Int)]
otherSide1 set i = map (\(_, j) -> (Set.delete (i, j) set, j)) (getPairs1 set i)
otherSide2 :: Set (Int, Int) -> Int -> [(Set (Int, Int), Int)]
otherSide2 set j = map (\(i, _) -> (Set.delete (i, j) set, i)) (getPairs2 set j)
otherSide :: Set (Int, Int) -> Int -> [(Set (Int, Int), Int)]
otherSide set i = otherSide1 set i ++ otherSide2 set i

bridge :: Set (Int, Int) -> Int -> [Int]
bridge set init = case otherSide set init of
                    [] -> [init]
                    (newSet, otherSide):_ -> init:(bridge newSet otherSide)

bridges :: Set (Int, Int) -> Int -> [[Int]]
bridges set init = case otherSide set init of
                    []  -> [[init]]
                    foo -> map (init:) $ foo >>= (\(newSet, otherSide) -> bridges newSet otherSide)

strength :: [Int] -> Int
strength l = (foldl (+) 0 l) * 2 - (last l)

main = do
  c <- getContents
  let available = Set.fromList $ map (read2 . break (=='/')) $ lines c
  let brs = bridges available 0
  let strengths = map strength brs
  print $ maximum strengths

  let maxLen = maximum $ map length brs
  let longest = filter (\l -> length l == maxLen) brs
  let strengths = map strength longest
  print $ maximum strengths
