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
