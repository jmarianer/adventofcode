import qualified Tablet as Tablet

import qualified Data.Map.Strict as Map

import Data.List
import Data.Maybe
import Util

main = do
  c <- getContents
  let prog = Tablet.parse c
      progrun = Tablet.iterate prog Map.empty
  print $ count (=="mul") $ catMaybes $ map (Tablet.getInstruction prog) progrun
