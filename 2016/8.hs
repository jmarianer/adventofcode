{-# LANGUAGE OverloadedStrings #-}
import Site

import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import Control.Applicative
import Data.Attoparsec.Text
import Data.List

data Instruction = Rect Int Int | Col Int Int | Row Int Int deriving Show

parseRect = do
  string "rect "
  a <- decimal
  string "x"
  b <- decimal
  return $ Rect a b

parseRow = do
  string "rotate row y="
  a <- decimal
  string " by "
  b <- decimal
  return $ Row a b

parseCol = do
  string "rotate column x="
  a <- decimal
  string " by "
  b <- decimal
  return $ Col a b

parseInst = parseRect <|> parseRow <|> parseCol

fromRight :: Either a b -> b
fromRight (Right b) = b

rotate :: Int -> [a] -> [a]
rotate i xs = back ++ front
  where (front, back) = splitAt (length xs - i) xs

performInst :: [String] -> Instruction -> [String]
performInst prev (Rect x y) = map on first ++ second
  where (first, second) = splitAt y prev
        on :: String -> String
        on line = replicate x '#' ++ drop x line
performInst prev (Col x i) = transpose $ performInst (transpose prev) (Row x i)
performInst prev (Row y i) = first ++ [rotate i second] ++ third
  where (first, second:third) = splitAt y prev

putState :: [String] -> IO ()
putState = putStrLn . intercalate "\n"

initial = replicate 6 $ replicate 50 '.'

main = do
  c <- TIO.getContents
  let instructions = map (fromRight . parseOnly parseInst) $ T.lines c
  let finalState = foldl performInst initial $ instructions
  print $ length $ filter (=='#') $ concat finalState
  putState finalState
