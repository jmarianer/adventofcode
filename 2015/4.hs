{-# LANGUAGE OverloadedStrings #-}
import Site

import qualified Crypto.Hash.MD5 as MD5
import qualified Data.ByteString as BS
import qualified Data.ByteString.Base16 as Hex

import Data.List
import Data.Text.Encoding

hash = Hex.encode . MD5.hash

startsWithZeros = BS.isPrefixOf "00000"

main = do
  print $ findIndex (BS.isPrefixOf "00000") $ hashes hash "bgvyzdsv"
  print $ findIndex (BS.isPrefixOf "000000") $ hashes hash "bgvyzdsv"
