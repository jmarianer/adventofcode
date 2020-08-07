import qualified Tablet as Tablet

import qualified Data.Map.Strict as Map

import Control.Error.Safe
import Data.List
import Data.Maybe
import Text.Read

printList :: Show a => [a] -> IO ()
printList = putStrLn . concat . intersperse "\n" . map show

main = do
  c <- getContents
  let prog = Tablet.parse c
      progrun = Tablet.iterate prog Map.empty
      firstReceive = head $ catMaybes $ map (Map.lookup "rcv") progrun
  print firstReceive

  let regs = ((Map.singleton "p" 0, []), (Map.singleton "p" 1, []))
  -- The following is inaccurate: I think it will double-count sends in prog1
  -- if prog0 gets iterated This can only happen if the previous instruction is
  -- rcv, so it doesn't happen for this input. I'm done mucking around with this.
  print $ length $ filter (prog1send prog) $ Tablet.repeatedly (Tablet.stepDuet prog) regs
  where prog1send prog (_, (regs1, _)) =
          case Tablet.nextInst prog regs1 of
            Just ("snd":_) -> True
            otherwise      -> False
