{-# LANGUAGE OverloadedStrings #-}
import Site

import qualified Data.Map as Map
import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import Data.Attoparsec.Text
import Data.Either
import Data.List
import Util

data Node = Node { x :: Int,
                   y :: Int,
                   size :: Int,
                   used :: Int,
                   avail :: Int } deriving (Show, Eq)

parseLine :: Parser Node
parseLine = do
  string "/dev/grid/node-x"
  x <- decimal
  string "-y"
  y <- decimal
  skipSpace
  size <- decimal
  string "T"
  skipSpace
  used <- decimal
  string "T"
  skipSpace
  avail <- decimal
  string "T"
  return $ Node x y size used avail

main = do
  c <- TIO.getContents
  let nodes = rights $ map (parseOnly parseLine) $ T.lines c
  let viablePairs = [(n1, n2) | n1 <- nodes, n2 <- nodes, n1 /= n2, avail n2 > used n1, used n1 /= 0]
  print $ length viablePairs

{- This only solves part I. I did part II manually by noticing the similarity
 - with the sample, and from vast experience doing 15-puzzles. :-)
 -
 - The input I got has a row of blockers (huge, full cells whose data is going
 - nowhere) at y=12, x=6..37, and an empty cell at (16, 23). We move this empty
 - cell to (6, 23) (11 moves), then to (5, 0) (23 moves), and then to (37, 0)
 - (32 moves) where the goal was originally. Now the goal is at (36, 0) and the
 - empty cell is to its right. To move the goal one space to the left takes
 - five moves (down-left-left-up-right), and we need to repeat that 36 times.
 -
 - Therefore the total number of moves is 11 + 23 + 32 + 36*5 = 246.
 -}
