module Tablet where

import qualified Data.Map.Strict as Map

import Control.Error.Safe
import Data.List
import Text.Read

type Instruction = [String]
type Registers = Map.Map String Int
data TabletProg = TabletProg [Instruction] deriving Show

-- | Keep applying the function to transform the value, until it yields
--   Nothing.  Returns the sequence of transformed values.
-- Found this buried in HaXml.
repeatedly :: (a->Maybe a) -> a -> [a]
repeatedly f x = case f x of Nothing -> []
                             Just y  -> y : repeatedly f y

parse :: String -> TabletProg
parse = TabletProg . map words . lines

getVal :: String -> Registers -> Int
getVal val regs =
  case (readMaybe val :: Maybe Int) of
    Just val' -> val'
    Nothing   -> Map.findWithDefault 0 val regs

execute :: Instruction -> Registers -> Registers
execute ["snd", val] regs = Map.insert "snd" (getVal val regs) regs
execute ["set", reg, val] regs = Map.insert reg (getVal val regs) regs
execute ["add", reg, val] regs = Map.update (Just . (+) (getVal val regs)) reg regs
execute ["sub", reg, val] regs = Map.update (Just . (flip (-)) (getVal val regs)) reg regs
execute ["mul", reg, val] regs = Map.update (Just . (*) (getVal val regs)) reg regs
execute ["mod", reg, val] regs = Map.update (Just . (flip mod) (getVal val regs)) reg regs
execute ["rcv", val] regs =
  if getVal val regs == 0
  then regs
  else Map.insert "rcv" (Map.findWithDefault 0 "snd" regs) regs
execute ["jgz", val1, val2] regs =
  if getVal val1 regs > 0
  then Map.update (Just . (+) (getVal val2 regs - 1)) "pc" regs
  else regs
execute ["jnz", val1, val2] regs =
  if getVal val1 regs /= 0
  then Map.update (Just . (+) (getVal val2 regs - 1)) "pc" regs
  else regs

step :: TabletProg -> Registers -> Maybe Registers
step (TabletProg insts) regs = 
  case insts `atZ` Map.findWithDefault 0 "pc" regs of
    Nothing   -> Nothing
    Just inst -> Just $ Map.alter increasePC "pc" $ execute inst regs
  where increasePC Nothing  = Just 1
        increasePC (Just x) = Just $ x+1

iterate :: TabletProg -> Registers -> [Registers]
iterate = repeatedly . Tablet.step

getInstruction :: TabletProg -> Registers -> String
getInstruction (TabletProg insts) regs =
  case insts `atZ` Map.findWithDefault 0 "pc" regs of
    Nothing   -> ""
    Just inst -> head inst
