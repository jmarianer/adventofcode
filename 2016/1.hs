{-# LANGUAGE OverloadedStrings #-}
import Site

import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import Data.Attoparsec.Text
import Data.List

parseDir :: Parser Direction
parseDir = choice [char 'L' >> return Lt, char 'R' >> return Rt]

parseMotion :: Parser (Direction, Int)
parseMotion = do
  dir <- parseDir
  int <- decimal
  return (dir, int)

parseMotions = parseMotion `sepBy` (string ", ")
  
move :: (Int, Int, Direction) -> (Direction, Int) -> [(Int, Int, Direction)]
move (i, j, dir) (turn, go) = map (\(i1, j1) -> (i1, j1, newDir)) locations
  where newDir = (if turn == Lt then turnLeft else turnRight) dir
        locations = Data.List.take go $ tail $ iterate (Site.move newDir) (i, j)

main = do
  c <- TIO.getContents
  let Right motions = parseOnly parseMotions c
  let locations = map (\(i, j, _) -> (i, j)) $ concat $ scanl (Main.move . last) [(0,0,Up)] motions

  -- Part I
  let (i, j) = last locations
  print $ abs i + abs j

  -- Part II
  let visitedTwice = map head $ filter (\l -> length l > 1) $ group $ sort locations
  let stepNos = map (\p -> (elemIndices p locations) !! 1) visitedTwice
  let (i, j) = locations !! minimum stepNos
  print $ abs i + abs j
