import Data.List

posCount = [5, 13, 17, 3, 19, 7]
initPos  = [2, 7, 10, 2, 9, 0]
{-posCount = [5, 2]
initPos  = [4, 1]-}

steps posCount initPos = elemIndex zeros $ iterate (step posCount) initPos'
  where initPos' = zipWith (+) initPos [1..]
        zeros = replicate (length initPos) 0
        step = zipWith step1
        step1 p i = (i+1) `mod` p



main = do
  print $ steps posCount initPos
  print $ steps (posCount ++ [11]) (initPos ++ [0])
