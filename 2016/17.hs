{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TupleSections #-}
import Site

import qualified Crypto.Hash.MD5 as MD5
import qualified Data.ByteString as BS
import qualified Data.ByteString.Base16 as Hex
import qualified Data.Map as Map
import qualified Data.Text as T

import Data.Text.Encoding

type State = ((Int, Int), String)

--hash :: String -> [GHC.Word.Word8] 
hash = BS.unpack . Hex.encode . MD5.hash . encodeUtf8 . T.pack

adjacent :: State -> [State]
adjacent ((3, 3), _) = []
adjacent (loc, dirs) = map move' validDirs
  where move' dir = (move dir loc, dirs ++ (take 1 $ show dir))
        validDirs :: [Direction]
        validDirs = map fst $ filter ((>97) . snd) $ zip [Up, Dn, Lt, Rt] $ hash dirs

adjacentAndValid :: State -> [State]
adjacentAndValid = filter valid . adjacent
  where valid ((x, y), _) = x >= 0 && y >= 0 && x <= 3 && y <= 3

start = ((0, 0), "rrrbmfta")
adjacency = map (,()) . adjacentAndValid
goal (a, _) = a == (3, 3)

findEndings :: Map.Map State x -> [String]
findEndings = map snd . filter goal . Map.keys --map fst . filter goal . Map.keys

main = do
  print $ drop 8 $ head $ findEndings $ bfs start adjacency goal Nothing
  print $ maximum $ map ((subtract 8) . length) $ findEndings $ bfs start adjacency (const False) (Just 500)
