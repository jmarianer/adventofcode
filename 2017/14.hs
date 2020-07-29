import Data.Bits

import Knothash

-- Test key = "flqrgnkx"
key = "xlqgujun"

main = do
  let allBytes = map (\n -> hashToList (key ++ "-" ++ (show n))) [0..127]
  print $ foldl (+) 0 $ map popCount $ concat allBytes
