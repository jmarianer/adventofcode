{-# LANGUAGE OverloadedStrings #-}
import Site

import qualified Data.Text as T
import qualified Data.Text.IO as TIO

charToDir :: Char -> Direction
charToDir 'R' = Rt
charToDir 'L' = Lt
charToDir 'U' = Up
charToDir 'D' = Dn

move1 :: (Int, Int) -> Direction -> (Int, Int)
move1 ij dir = (clamp i, clamp j)
  where (i, j) = Site.move dir ij
        clamp i = min 2 $ max 0 i

move2 :: (Int, Int) -> Direction -> (Int, Int)
move2 (i, j) dir = case dir of
  Up -> (max (start j) $ min (end j) (i-1), j)
  Dn -> (max (start j) $ min (end j) (i+1), j)
  Lt -> (i, max (start i) $ min (end i) (j-1))
  Rt -> (i, max (start i) $ min (end i) (j+1))
  where start :: Int -> Int
        start 0 = 2
        start 1 = 1
        start 2 = 0
        start 3 = 1
        start 4 = 2
        end :: Int -> Int
        end 0 = 2
        end 1 = 3
        end 2 = 4
        end 3 = 3
        end 4 = 2

digit1 :: (Int, Int) -> Int
digit1 (i, j) = i * 3 + j + 1

digit2 :: (Int, Int) -> Char
digit2 (0, 2) = '1'
digit2 (1, 1) = '2'
digit2 (1, 2) = '3'
digit2 (1, 3) = '4'
digit2 (2, 0) = '5'
digit2 (2, 1) = '6'
digit2 (2, 2) = '7'
digit2 (2, 3) = '8'
digit2 (2, 4) = '9'
digit2 (3, 1) = 'A'
digit2 (3, 2) = 'B'
digit2 (3, 3) = 'C'
digit2 (4, 2) = 'D'

main = do
  c <- TIO.getContents
  let directions = (map.map) charToDir $ map T.unpack $ T.lines c

  -- Part I
  let digits = map digit1 $ tail $ scanl (foldl move1) (1,1) directions
  putStrLn $ concat $ map show digits

  -- Part II
  let locations = tail $ scanl (foldl move2) (2,0) directions
  putStrLn $ map digit2 locations
