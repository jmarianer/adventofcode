{-# LANGUAGE OverloadedStrings #-}
import Site

import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import Data.Attoparsec.Text

type Triple = (Int, Int, Int)
trianglePossible :: Triple -> Bool
trianglePossible (a, b, c) =
  (a + b > c) && (b + c > a) && (c + a > b)

getTriples1 :: [Int] -> [Triple]
getTriples1 [] = []
getTriples1 (a:b:c:rest) = (a,b,c):(getTriples1 rest)

getTriples2 :: [Int] -> [Triple]
getTriples2 [] = []
getTriples2 (a:b:c:d:e:f:g:h:i:rest) = (a,d,g):(b,e,h):(c,f,i):(getTriples2 rest)

main = do
  c <- TIO.getContents
  let numbers = (map (read.T.unpack) $ T.words c :: [Int])

  -- Part I
  print $ length $ filter trianglePossible $ getTriples1 numbers

  -- Part II
  print $ length $ filter trianglePossible $ getTriples2 numbers
