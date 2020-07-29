import Text.Read
import qualified Data.Map.Strict as Map

nextinst regs = Map.update (Just . (+1)) "pc" regs

getVal val regs =
  case (readMaybe val :: Maybe Int) of
    Just val' -> val'
    Nothing   -> Map.findWithDefault 0 val regs

execute ["snd", val] regs = Map.insert "snd" (getVal val regs) regs
execute ["set", reg, val] regs = Map.insert reg (getVal val regs) regs
execute ["add", reg, val] regs = Map.update (Just . (+) (getVal val regs)) reg regs
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

runprog prog regs = nextinst $ execute inst regs
  where 
        inst = prog !! Map.findWithDefault 0 "pc" regs

main = do
  c <- getContents
  let prog = map words $ lines c
  let progrun = iterate (runprog prog) $ Map.singleton "pc" 0
  let firstReceive = head $ filter (Map.member "rcv") progrun
  print $ Map.findWithDefault 0 "rcv" firstReceive
