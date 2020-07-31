import Util
import Text.Read
import Control.Error.Safe
import Data.Maybe
import Data.List
import qualified Data.Map.Strict as Map

-- | Keep applying the function to transform the value, until it yields
--   Nothing.  Returns the sequence of transformed values.
-- Found this buried in HaXml.
repeatedly :: (a->Maybe a) -> a -> [a]
repeatedly f x = case f x of Nothing -> []
                             Just y  -> y : repeatedly f y

nextinst regs = Map.update (Just . (+1)) "pc" regs

getVal val regs =
  case (readMaybe val :: Maybe Int) of
    Just val' -> val'
    Nothing   -> Map.findWithDefault 0 val regs

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
execute ["jnz", val1, val2] regs =
  if getVal val1 regs /= 0
  then Map.update (Just . (+) (getVal val2 regs - 1)) "pc" regs
  else regs
execute ["jgz", val1, val2] regs =
  if getVal val1 regs > 0
  then Map.update (Just . (+) (getVal val2 regs - 1)) "pc" regs
  else regs

runinst :: [[String]] -> Map.Map String Int -> Maybe (Map.Map String Int)
runinst prog regs = case inst prog regs of
                       Nothing -> Nothing
                       Just inst' -> Just $ nextinst $ execute inst' regs

inst prog regs = prog `atZ` Map.findWithDefault 0 "pc" regs

maybediv2 n = if even n then Just $ n `div` 2 else Nothing

main = do
  c <- getContents
  let prog = map words $ lines c
  let progrun = repeatedly (runinst prog) $ Map.fromList [("h", 0), ("pc", 0)]
  let insts = mapMaybe (inst prog) progrun
  print $ count (\[inst, _, _] -> inst == "mul") insts

  --let progrun = repeatedly (runinst prog) $ Map.fromList [("a", 1), ("pc", 0)]
  putStrLn $ concat $ intersperse "\n" $ map show progrun
