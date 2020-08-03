{-# LANGUAGE OverloadedStrings #-}
import Site

import qualified Crypto.Hash.MD5 as MD5
import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import qualified Data.ByteString as BS
import qualified Data.ByteString.Base16 as Hex

import Data.Text.Encoding
import Data.Char
import Data.List
import Data.Maybe

digit = (+48)

interestingHash :: BS.ByteString -> Bool
interestingHash d = BS.take 5 d == "00000" && BS.index d 5 `elem` [digit 0..digit 7]

main = do
  let myHashes = hashes (Hex.encode . MD5.hash) "reyedfim"
  print $ BS.pack $ map (\d -> BS.index d 5) $ take 8 $ filter (\d -> BS.take 5 d == "00000") myHashes


  let locletter = map (\d -> (BS.index d 5 - digit 0, BS.index d 6)) $ filter interestingHash myHashes
      locletters = map (\n -> find ((==n) . fst) locletter) [0..7]
      letters = map (snd . fromJust) locletters
  print $ BS.pack letters
