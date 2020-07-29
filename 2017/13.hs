import Data.List
import Data.List.Ordered

locations :: Int -> [Int]
locations 1 = [0]
locations 2 = [0, 1]
locations n = [0..(n-1)] ++ (reverse [1..(n-2)])

catches depthsRanges initTime = filter (\(d, r) -> ((cycle $ locations r) !! (d + initTime)) == 0) depthsRanges

safeTimes (d, r) = findIndices (/= 0) $ drop d $ cycle $ locations r

main = do
  c <- getContents
  let depthsRanges = map (\(d:r:[]) -> (read $ init d, read r)) $ map words $ lines c
  let catches0 = catches depthsRanges 0
  print $ foldl (+) 0 $ map (\(d, r) -> d * r) catches0

  -- This is sound but takes too long
  --let catchCount = map (length . catches depthsRanges) [0..]
  --let zeroCatches = findIndices (== 0) catchCount
  --print $ head zeroCatches

  -- This takes ~half a minute to run on my not-amazing laptop
  let allSafeTimes = map safeTimes depthsRanges
  print $ head $ foldl isect [0..] $ allSafeTimes
