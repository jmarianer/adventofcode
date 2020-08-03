{-# LANGUAGE OverloadedStrings #-}
import Site

import qualified Crypto.Hash.MD5 as MD5
import qualified Data.ByteString as BS
import qualified Data.ByteString.Base16 as Hex

import Data.List
import Data.List.Extra
import Data.List.Split

firstTuple n s = case filter allSame $ divvy n 1 s of
                 c:_ -> Just $ head c
                 _   -> Nothing

has3and5 (h:hs) = case firstTuple 3 h of
                  Nothing -> False
                  Just c  -> any (== Just c) $ map (firstTuple 5) hs

hashOnce = Hex.encode . MD5.hash
hashMulti s = (iterate hashOnce s) !! 2017

main = do
  --print $ take 64 $ findIndices has3and5 $ divvy 1000 1 $ map BS.unpack $ hashes hashOnce "jlmsuwbz"
  print $ take 64 $ findIndices has3and5 $ divvy 1000 1 $ map BS.unpack $ hashes hashMulti "jlmsuwbz"
  
