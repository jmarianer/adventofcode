import qualified Tablet as Tablet

import qualified Data.Map.Strict as Map

import Control.Error.Safe
import Data.List
import Data.Maybe
import Text.Read

{-
-- TODO: Factor this out of here and 23.hs

nextinst1 (regs, receive, send) = (Map.update (Just . (+1)) "pc" regs, receive, send)


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
-}

main = do
  c <- getContents
  let prog = Tablet.parse c
      progrun = Tablet.iterate prog Map.empty
      firstReceive = head $ filter (Map.member "rcv") progrun
  print $ Map.findWithDefault 0 "rcv" firstReceive

  --let regs = map fst' $ duet prog
  --putStrLn $ concat $ intersperse "\n" $ map show $ regs
  --print $ duet prog
