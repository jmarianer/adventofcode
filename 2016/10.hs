{-# LANGUAGE OverloadedStrings #-}
import Site

import qualified Data.Text.Lazy as T
import qualified Data.Text.Lazy.IO as TIO
import Control.Applicative
import Control.Monad
import Control.Monad.Trans.Writer
import qualified Data.Attoparsec.Text.Lazy as P
import Data.Either
import Data.List
import Data.Maybe
import qualified Data.Map as Map
import Formatting

data To = Output Int | Bot Int deriving Show
data Instruction = Inst To To deriving Show

parseTo :: P.Parser To
parseTo = do
  a <- (P.string "bot " >> return Bot) <|> (P.string "output " >> return Output)
  b <- P.decimal
  return $ a b

parseInst :: P.Parser (Int, Instruction)
parseInst = do
  P.string "bot "
  b <- P.decimal
  P.string " gives low to "
  to1 <- parseTo
  P.string " and high to "
  to2 <- parseTo
  return (b, Inst to1 to2)

parseVal :: P.Parser (Int, Int)
parseVal = do
  P.string "value "
  v <- P.decimal
  P.string " goes to bot "
  b <- P.decimal
  return (b, v)

type Instructions = Map.Map Int Instruction
type State = Map.Map Int Int

give1 :: Instructions -> Int -> To -> State -> Writer T.Text State
give1 insts value to state =
  case to of
    Output n -> do
      tell $ format ("Output" % int % ": " % int % "\n") n value
      return state
    Bot n -> giveValue insts state (n, value)

giveValue :: Instructions -> State -> (Int, Int) -> Writer T.Text State
giveValue insts state (bot, value) =
  case Map.lookup bot state of
    Nothing -> return $ Map.insert bot value state
    Just oldValue -> let low = min value oldValue
                         high = max value oldValue
                         Just (Inst lowTo highTo) = Map.lookup bot insts
                     in do
                       tell $ format ("Bot " % int % " compares " % int % ", " % int % "\n") bot low high
                       let state1 = Map.delete bot state
                       state2 <- give1 insts low lowTo state1
                       give1 insts high highTo state2


getParse :: P.Result a -> Maybe a
getParse (P.Done _ a) = Just a
getParse _ = Nothing

main = do
  c <- TIO.getContents
  let lines = T.lines c
      parsedInsts = catMaybes $ map (getParse . P.parse parseInst) lines
      insts :: Instructions
      insts = Map.fromList parsedInsts
      values = catMaybes $ map (getParse . P.parse parseVal) lines
      (_, written) = runWriter $ foldM (giveValue insts) Map.empty values
  --print $ (return Map.empty) >>= giveValue insts (4, 2) >>= giveValue insts (4, 5)
  TIO.putStrLn written
