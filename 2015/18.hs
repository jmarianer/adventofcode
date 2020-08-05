import qualified Data.Map.Strict as Map

import Debug.Trace
import Util

type State = Map.Map (Int, Int) Char

add (x, y) (dx, dy) = (x + dx, y + dy)

animate :: State -> State
animate state = Map.mapWithKey newState state
  where newState :: (Int, Int) -> Char -> Char
        newState loc c = case (c, neighborCount) of
                           ('#', 3) -> '#'
                           ('#', 4) -> '#'
                           ('.', 3) -> '#'
                           _        -> '.'
          where neighborCount = count (=='#') $ map (\delta -> Map.findWithDefault '.' (loc `add` delta) state) $ [(dx, dy) | dx <- [-1, 0, 1], dy <- [-1, 0, 1]]

showState :: State -> String
showState state = concatMap getLine [1..100] ++ "\n"
  where getLine :: Int -> String
        getLine y = map getLight [1..100] ++ "\n"
          where getLight x = Map.findWithDefault '.' (x, y) state

lightUpCorners = Map.union $ Map.fromList [((1,1), '#'), ((1,100), '#'), ((100,1), '#'), ((100,100), '#')]
animate1 = lightUpCorners . animate

main = do
  c <- getContents
  let coords = concat $ zipWith (\y xc -> map (\(x, c) -> ((x, y), c)) xc) [1..] $ map (zip [1..]) $ lines c
  let initialState = Map.fromList coords

  --let states = take 101 $ iterate animate initialState
  --putStr $ concat $ map showState $ states
  --print $ count (=='#') $ Map.elems $ last states

  let states = take 101 $ iterate animate1 $ lightUpCorners initialState
  putStr $ concat $ map showState $ states
  print $ count (=='#') $ Map.elems $ last states
