import Text.Read
import Data.List
import Control.Error.Safe
import Data.Maybe
import qualified Data.Map.Strict as Map

-- TODO: Factor this out of here and 23.hs
-- | Keep applying the function to transform the value, until it yields
--   Nothing.  Returns the sequence of transformed values.
-- Found this buried in HaXml.
repeatedly :: (a->Maybe a) -> a -> [a]
repeatedly f x = case f x of Nothing -> []
                             Just y  -> y : repeatedly f y

nextinst regs = Map.update (Just . (+1)) "pc" regs
nextinst1 (regs, receive, send) = (Map.update (Just . (+1)) "pc" regs, receive, send)

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

-- execute :: instruction -> registers -> registers
-- execute1 :: instruction -> (registers, receive, lastsend) -> (registers, receive, maybe send)
execute1 ["snd", val] (regs, receive) = (regs, receive, Just $ getVal val regs)
execute1 ["rcv", val] (regs, receive) =
  (Map.insert val (head receive) regs, tail receive, Nothing)
execute1 inst (regs, receive) = (execute inst regs, receive, Nothing)

runinst prog regs = nextinst $ execute inst regs
  where inst = prog !! Map.findWithDefault 0 "pc" regs

runinst1 prog (regs, receive, _) =
    case maybeInst of
      Nothing -> Nothing
      Just inst -> Just $ nextinst1 $ execute1 inst (regs, receive)
  where maybeInst = prog `atZ` Map.findWithDefault 0 "pc" regs

third (a,b,c) = c

duet prog = prog1send
  where prog0 = repeatedly (runinst1 prog) $ (Map.fromList [("p", 0), ("pc", 0)], prog1send, Nothing)
        prog1 = repeatedly (runinst1 prog) $ (Map.fromList [("p", 1), ("pc", 0)], prog0send, Nothing)
        prog0send = catMaybes $ map third prog0
        prog1send = catMaybes $ map third prog1

fst' (a,b,c) = a

main = do
  c <- getContents
  let prog = map words $ lines c
  let progrun = iterate (runinst prog) $ Map.singleton "pc" 0
  let firstReceive = head $ filter (Map.member "rcv") progrun
  print $ Map.findWithDefault 0 "rcv" firstReceive

  --let regs = map fst' $ duet prog
  --putStrLn $ concat $ intersperse "\n" $ map show $ regs
  print $ duet prog
