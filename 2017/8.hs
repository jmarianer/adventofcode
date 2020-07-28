import qualified Data.Map.Strict as Map

readInst line = (target, delta, source, comp, read value :: Int)
  where target:incdec:delta':_if:source:comp:value:[] = words line
        delta = if incdec == "inc"
                then read delta' :: Int
                else - (read delta' :: Int)

compOp comp = case comp of
         ">" -> (>)
         "<" -> (<)
         "<=" -> (<=)
         ">=" -> (>=)
         "==" -> (==)
         "!=" -> (/=)

runInst :: Map.Map String Int -> (String, Int, String, String, Int) -> Map.Map String Int
runInst regs (target, delta, source, comp, value) =
  if compOp comp sourceValue value
  then Map.insert target (targetValue + delta) regs
  else regs
  where sourceValue = Map.findWithDefault 0 source regs
        targetValue = Map.findWithDefault 0 target regs

runInstWithMax :: (Map.Map String Int, Int) -> (String, Int, String, String, Int) -> (Map.Map String Int, Int)
runInstWithMax (regs, oldMax) inst = (newRegs, newMax)
  where newRegs = runInst regs inst
        newMax  = maximum (oldMax:(Map.elems newRegs))

main = do
  c <- getContents
  let prog = map readInst $ lines c
  let after1 = runInst Map.empty (head prog)
  let (finalState, finalMax) = foldl runInstWithMax (Map.empty, 0) prog
  print $ maximum $ Map.elems finalState
  print finalMax
