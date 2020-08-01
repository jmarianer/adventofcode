{-# LANGUAGE OverloadedStrings #-}
import Site

import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import qualified Data.ByteString as BS
import qualified Data.ByteString.Base16 as Hex
import qualified Crypto.Hash.MD5 as MD5

import Data.Text.Encoding
import Data.Char

hashes :: T.Text -> [BS.ByteString]
hashes s = map hash [0..]
  where hash :: Int -> BS.ByteString
        hash n = Hex.encode $ MD5.hash $ encodeUtf8 $ T.concat [s, T.pack $ show n]

interestingHash :: BS.ByteString -> Bool
interestingHash d = BS.take 5 d == "00000" && BS.index d 5 `elem` [48..55]



main = do
  --print $ BS.pack $ map (\d -> BS.index d 5) $ take 8 $ filter (\d -> BS.take 5 d == "00000") $ hashes "reyedfim"

  let locletter = map (\d -> (BS.index d 5 - 48, BS.index d 6)) $ filter interestingHash $ hashes "abc"

