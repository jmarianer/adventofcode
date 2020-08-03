{-# LANGUAGE OverloadedStrings #-}
import Site

import qualified Data.Map as Map
import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import Data.Bits
import Data.List

{- Test data:
input = 10
target = (7, 4)
-}
input = 1350
target = (31, 39)

open :: (Int, Int) -> Bool
open (x, y) = even $ popCount (x*x + 3*x + 2*x*y + y + y*y + input)

draw True = '.'
draw False = '#'

adjacent :: (Int, Int) -> [((Int, Int), Direction)]
adjacent (x, y) = [((x, y+1), Dn),
                   ((x, y-1), Up),
                   ((x-1, y), Lt),
                   ((x+1, y), Rt)]
adjacentAndOpen = filter valid . adjacent
  where valid ((x, y), _) = x>=0 && y>=0 && open (x, y)

main = do
  -- debugging:
  -- TIO.putStrLn $ T.intercalate "\n" $ map (\y -> (T.pack $ map (\x -> draw $ open (x, y)) [0..9])) [0..9]
  let directions = bfs (1, 1) adjacentAndOpen (== target) Nothing
      Just dir = Map.lookup target directions
  print $ length $ dir

  let directions = bfs (1, 1) adjacentAndOpen (== target) (Just 50)
  print $ length $ Map.keys directions

