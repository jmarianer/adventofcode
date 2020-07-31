import qualified Data.Map.Strict as Map
import Util
import Data.Matrix as Matrix
import Data.List as List
import Data.List.Split

type Rulebook = Map.Map String String

linesToDict :: [String] -> Rulebook
linesToDict = Map.fromList . concat . map toPairs
  where toPairs s = let [from, _, to] = words s
                    in map (\f -> (f, x to)) $ allDirections $ x from
        x = filter (/= '/')

allDirections :: String -> [String]
allDirections s = map (\f -> concat $ f chunks) [id, flipH, flipV, flipH . flipV,
                                                 List.transpose,
                                                 List.transpose . flipH,
                                                 List.transpose . flipV,
                                                 List.transpose . flipH . flipV]
  where flipH = map reverse
        flipV = reverse
        size = if length s == 4 then 2 else 3
        chunks = chunksOf size s

partition :: Int -> Matrix a -> [[Matrix a]]
partition n matrix = [[submatrix (n*i+1) (n*i+n) (n*j+1) (n*j+n) matrix | j <- inds] | i <- inds ]
  where inds = [0..(ncols matrix `div` n) - 1]

unpartition :: [[Matrix a]] -> Matrix a
unpartition = foldl1 (<->) . map (foldl1 (<|>))

step :: Rulebook -> Matrix Char -> Matrix Char
step rulebook m = unpartition $ (map.map) step' $ Main.partition p m
  where p = if even (ncols m) then 2 else 3
        step' m' = Matrix.fromList (p+1) (p+1) $ Map.findWithDefault (replicate ((p+1)*(p+1)) 'x') (toList m') rulebook

sizeUp n = if even n then n `div` 2 * 3 else n `div` 3 * 4
countHashes = count (== '#')

iterateCounts :: Rulebook -> Map.Map String Int -> Map.Map String Int
iterateCounts rulebook oldCounts = Map.fromList $ map (\l -> (l, newVal l)) $ Map.keys oldCounts
  where newVal :: String -> Int
        newVal l = sum $ map (\subm -> Map.findWithDefault 0 (toList subm) oldCounts) $ concat $ Main.partition 3 $ step3 l
        step3 :: String -> Matrix Char
        step3 l = step rulebook $ step rulebook $ step rulebook $ Matrix.fromList 3 3 l

main = do
  c <- getContents
  let rulebook = linesToDict $ lines c
  let initialMatrix = Matrix.fromLists [".#.", "..#", "###"]
  let steps = iterate (step rulebook) initialMatrix
  print $ countHashes $ toList $ steps !! 5

  -- The trick for part II is to notice that every three steps, a 3x3 grows
  -- into a 9x9, and the 3x3 submatrices will grow independently. Therefore we
  -- simply count how many are on in the 9x9 that stems from each 3x3 and
  -- iterate that six times.
  let onlyThrees = filter (\l -> length l == 9) $ Map.keys rulebook
  let count0 = Map.fromList $ map (\l -> (l, countHashes l)) onlyThrees
  let count6 = (iterate (iterateCounts rulebook) count0) !! 6
  print $ Map.findWithDefault 0 (toList initialMatrix) count6
