import qualified Data.Map as Map

-- Generate the list [1,2,6,11,19,28...]
-- The differences are [1,4,5,8,9,13...]
-- The differences between even elements are always 4
--diffList = 1:([4,8..] >>= (\x -> [x, x+1]))
--theList = 1:(map (\(x,y) -> x + y) (l `zip` diffList))


-- That wasn't very useful. Let's try again
-- Generate the number of the "ring" for each number
-- There are 8n numbers in each ring, so
n `x` k = take k (repeat n)
--theList = 0:([1..] >>= (\n -> n `x` (8*n)))

-- Starting to get somewhere. OK, let's instead generate coordinates
direction = [2,4..] >>= (\n -> "R" ++ ('U' `x` (n-1)) ++ ('L' `x` n)
                            ++ ('D' `x` n) ++ ('R' `x` n))
move (x,y) 'R' = (x+1, y)
move (x,y) 'L' = (x-1, y)
move (x,y) 'U' = (x, y+1)
move (x,y) 'D' = (x, y-1)
theList = (0,0):(zipWith move theList direction)

-- Populate the grid as per part II. The grid is a Map (x, y) val,
-- and is always paired with a list of the insertions in order.
initGrid = (Map.singleton (0, 0) 1, [1])
populateElt (grid, list) (x, y) =
  (Map.insert (x, y) val grid, list ++ [val])
  where val = sum [Map.findWithDefault 0 (x + dx, y + dy) grid |
                   dx <- [-1, 0, 1], dy <- [-1, 0, 1]]

inpValue = 289326
main = do
  let (x, y) = theList !! (inpValue-1)
  print ((abs x) + (abs y))
  -- The 1000 below is really ugly. I'm not sure how to lazily
  -- generate both the grid and the list.
  -- Interestingly, I know exactly how to do it in Python...
  let insertions = snd (foldl populateElt initGrid (take 1000 $ tail theList))
  print $ head $ dropWhile (< inpValue) insertions
