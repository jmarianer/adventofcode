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

nextInst :: TabletProg -> Registers -> Maybe Instruction
nextInst (TabletProg insts) regs = insts `atZ` Map.findWithDefault 0 "pc" regs

parse :: String -> TabletProg
parse = TabletProg . map words . lines

getVal :: String -> Registers -> Int
getVal val regs =
  case (readMaybe val :: Maybe Int) of
    Just val' -> val'
    Nothing   -> Map.findWithDefault 0 val regs

executeBase :: Instruction -> Registers -> Registers
executeBase ["set", reg, val] regs = Map.insert reg (getVal val regs) regs
executeBase ["add", reg, val] regs = Map.update (Just . (+) (getVal val regs)) reg regs
executeBase ["sub", reg, val] regs = Map.update (Just . (flip (-)) (getVal val regs)) reg regs
executeBase ["mul", reg, val] regs = Map.update (Just . (*) (getVal val regs)) reg regs
executeBase ["mod", reg, val] regs = Map.update (Just . (flip mod) (getVal val regs)) reg regs
executeBase ["jgz", val1, val2] regs =
  if getVal val1 regs > 0
  then Map.update (Just . (+) (getVal val2 regs - 1)) "pc" regs
  else regs
executeBase ["jnz", val1, val2] regs =
  if getVal val1 regs /= 0
  then Map.update (Just . (+) (getVal val2 regs - 1)) "pc" regs
  else regs

executeSound :: Instruction -> Registers -> Registers
executeSound ["snd", val] regs = increasePC $ Map.insert "snd" (getVal val regs) regs
executeSound ["rcv", val] regs =
  if getVal val regs == 0
  then increasePC $ regs
  else increasePC $ Map.insert "rcv" (Map.findWithDefault 0 "snd" regs) regs
executeSound otherInst    regs = increasePC $ executeBase otherInst regs

increasePC :: Registers -> Registers
increasePC = Map.alter i' "pc"
  where i' Nothing  = Just 1
        i' (Just x) = Just $ x+1

step :: TabletProg -> Registers -> Maybe Registers
step prog regs = do
  inst <- nextInst prog regs
  return $ executeSound inst regs

iterate :: TabletProg -> Registers -> [Registers]
iterate = repeatedly . Tablet.step

getInstruction :: TabletProg -> Registers -> Maybe String
getInstruction (TabletProg insts) regs = do
  inst <- insts `atZ` Map.findWithDefault 0 "pc" regs
  return $ head inst

type RegsAndQueue = (Registers, [Int])

executeInOut :: Instruction -> RegsAndQueue -> (RegsAndQueue, Maybe Int)
executeInOut ["snd", val] (regs, queue) = ((increasePC $ regs, queue), Just $ getVal val regs)
executeInOut ["rcv", val] (regs, queue) = ((increasePC $ Map.insert val (head queue) regs, tail queue), Nothing)
executeInOut otherInst    (regs, queue) = ((increasePC $ executeBase otherInst regs, queue), Nothing)

addToQueue :: RegsAndQueue -> Maybe Int -> RegsAndQueue
addToQueue (regs, queue) (Just i) = (regs, queue ++ [i])
addToQueue (regs, queue) Nothing  = (regs, queue)

stepDuet :: TabletProg -> (RegsAndQueue, RegsAndQueue) -> Maybe (RegsAndQueue, RegsAndQueue)
stepDuet prog (regs0, regs1) = do
  -- How to choose which program to iterate:
  -- - If program i (i = 0 or 1) is about to execute a "rcv" instruction but
  --   has nothing in its queue, then we can't iterate it.
  -- - If we can iterate neither program then we're in a deadlock and return
  --   Nothing.
  -- - If neither situation applies (we can iterate either program), then
  --   arbitrarily decide to iterate program 0.
  -- - If either program ran off the edge, we also return Nothing. That
  --   shouldn't happen in a Duet.
  inst0 <- nextInst prog (fst regs0)
  inst1 <- nextInst prog (fst regs1)
  let canIterateProg0 = canIterate inst0 regs0
      canIterateProg1 = canIterate inst1 regs1
      deadlock = not (canIterateProg0 || canIterateProg1)
  if deadlock then Nothing else Just ()

  let (iterateProg0, maybeSend0) = executeInOut inst0 regs0
      (iterateProg1, maybeSend1) = executeInOut inst1 regs1
  return $ if canIterateProg0
           then (iterateProg0, addToQueue regs1 maybeSend0)
           else (addToQueue regs0 maybeSend1, iterateProg1)

  where canIterate inst (regs, queue) =
          case head inst of
            "rcv"     -> queue /= []
            otherwise -> True
