{-# LANGUAGE OverloadedStrings #-}
import Site

import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import Control.Applicative
import Data.Attoparsec.Text
import Data.Either
import Data.List
import Data.List.Index
import Data.Maybe
import Debug.Trace

rotateRight :: Int -> [a] -> [a]
rotateRight i xs = back ++ front
  where (front, back) = splitAt ((20*length xs - i) `mod` length xs) xs

rotateLeft :: Int -> [a] -> [a]
rotateLeft i xs = back ++ front
  where (front, back) = splitAt (i `mod` length xs) xs

rotateLetter :: Eq a => a -> [a] -> [a]
rotateLetter c list = rotateRight i list
  where Just i' = elemIndex c list
        i = i' + if i' >= 4 then 2 else 1

rotateLetterBack :: Eq a => a -> [a] -> [a]
rotateLetterBack c list = rotateRight i list
  where Just i' = elemIndex c list
        i = [7, -1, 2, -2, 1, -3, 0, -4] !! i'
{- old i  i'  i
 -     0  1   -1
 -     1  3   -2
 -     2  5   -3
 -     3  7   -4
 -     4  2   2
 -     5  4   1
 -     6  6   0
 -     7  0   7
 -}

exchange :: Int -> Int -> [a] -> [a]
exchange a b list = setAt a origB $ setAt b origA list
  where origA = list !! a
        origB = list !! b

swapChars :: (Eq a) => a -> a -> [a] -> [a]
swapChars a b list = exchange a' b' list
  where a' = fromJust $ elemIndex a list
        b' = fromJust $ elemIndex b list

reversePos :: Int -> Int -> [a] -> [a]
reversePos a b list = l1 ++ (reverse l2) ++ l3
  where (l12, l3) = splitAt (b+1) list
        (l1, l2) = splitAt a l12

movePos :: Int -> Int -> [a] -> [a]
movePos a b list = if a < b
  then let (l12, l3) = splitAt (b+1) list
           (l1, (c:l2)) = splitAt a l12
       in l1 ++ l2 ++ (c:l3)
  else let (l12, (c:l3)) = splitAt a list
           (l1, l2) = splitAt b l12
       in l1 ++ (c:l2) ++ l3

data Instruction = Exchange Int Int | Swap Char Char | RotateLeft Int | RotateRight Int | RotateLetter Char | Reverse Int Int | Move Int Int deriving Show

parseInput :: Parser Instruction
parseInput =
  do
    string "swap position " 
    p1 <- decimal
    string " with position "
    p2 <- decimal
    return $ Exchange p1 p2
  <|> do
    string "swap letter " 
    c1 <- anyChar
    string " with letter "
    c2 <- anyChar
    return $ Swap c1 c2
  <|> do
    string "rotate left "
    s <- decimal
    string " step"
    return $ RotateLeft s
  <|> do
    string "rotate right "
    s <- decimal
    string " step"
    return $ RotateRight s
  <|> do
    string "rotate based on position of letter "
    c <- anyChar
    return $ RotateLetter c
  <|> do
    string "reverse positions "
    p1 <- decimal
    string " through "
    p2 <- decimal
    return $ Reverse p1 p2
  <|> do
    string "move position "
    p1 <- decimal
    string " to position "
    p2 <- decimal
    return $ Move p1 p2

runInst :: Instruction -> String -> String
runInst (Exchange a b) = exchange a b
runInst (Swap a b) = swapChars a b
runInst (RotateLeft i) = rotateLeft i
runInst (RotateRight i) = rotateRight i
runInst (RotateLetter c) = rotateLetter c
runInst (Reverse i j) = reversePos i j
runInst (Move i j) = movePos i j

reverseInst :: Instruction -> String -> String
reverseInst (Exchange a b) = exchange a b
reverseInst (Swap a b) = swapChars a b
reverseInst (RotateLeft i) = rotateRight i
reverseInst (RotateRight i) = rotateLeft i
reverseInst (RotateLetter c) = rotateLetterBack c
reverseInst (Reverse i j) = reversePos i j
reverseInst (Move i j) = movePos j i

main = do
  c <- TIO.getContents
  let instructions = rights $ map (parseOnly parseInput) $ T.lines c
  print $ foldl (flip runInst) "abcdefgh" instructions
  print $ foldl (flip reverseInst) "fbgdceah" $ reverse instructions
