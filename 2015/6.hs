{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE OverloadedStrings #-}
import Site

import qualified Data.Map.Strict as Map
import qualified Data.Set as Set
import qualified Data.Text as T
import qualified Data.Text.IO as TIO

import Control.Applicative
import Data.Attoparsec.Text
import Data.Either
import Data.Set (Set)

data InstType = On | Off | Toggle
data Instruction = Instruction InstType Int Int Int Int

parseInstType :: Parser InstType
parseInstType =
  do 
    string "turn on "
    return On
  <|> do
    string "toggle "
    return Toggle
  <|> do
    string "turn off "
    return Off

parseInst :: Parser Instruction
parseInst = do
  instType <- parseInstType
  x1 <- decimal
  char ','
  y1 <- decimal
  string " through "
  x2 <- decimal
  char ','
  y2 <- decimal

  return $ Instruction instType x1 y1 x2 y2

symmdiff :: Ord a => Set a -> Set a -> Set a
symmdiff a b = Set.difference a b `Set.union` Set.difference b a

-- Part I
type Lights1 = Set (Int, Int)
apply1 :: Lights1 -> Instruction -> Lights1
apply1 prev (Instruction instType x1 y1 x2 y2) = (operation instType) prev $ Set.fromList [(x, y) | x <- [x1..x2], y <- [y1..y2]]
  where operation On = Set.union
        operation Off = Set.difference
        operation Toggle = symmdiff

-- Part II
type Lights2 = Map.Map (Int, Int) Int
apply2 :: Lights2 -> Instruction -> Lights2
apply2 prev (Instruction instType x1 y1 x2 y2) = seq prev $ foldl (foldArg instType) prev $ [(x, y) | x <- [x1..x2], y <- [y1..y2]]
  where foldArg :: InstType -> Lights2 -> (Int, Int) -> Lights2
        foldArg On a xy = Map.alter (on 1) xy a
        foldArg Off a xy = Map.alter (off) xy a
        foldArg Toggle a xy = Map.alter (on 2) xy a
        on :: Int -> Maybe Int -> Maybe Int
        on i Nothing = Just i
        on i (Just k) = Just $ k + i
        off :: Maybe Int -> Maybe Int
        off Nothing = Nothing
        off (Just k) = if k > 1 then Just $ k - 1 else Nothing

main = do
  c <- TIO.getContents
  let insts = rights $ map (parseOnly parseInst) $ T.lines c
  print $ length $ Set.toList $ foldl apply1 Set.empty insts
  print $ sum $ Map.elems $ foldl apply2 Map.empty insts
