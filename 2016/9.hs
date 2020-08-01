{-# LANGUAGE OverloadedStrings #-}
import Site

import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import Control.Applicative
import qualified Data.Attoparsec.Text as P
import Data.List

uncompressed :: P.Parser T.Text
uncompressed = do
  -- no P.takeWhile1
  c1 <- P.anyChar
  cs <- P.takeWhile (/= '(')
  return $ T.pack (c1:T.unpack cs)

compressed :: P.Parser T.Text
compressed = do
  P.char '('
  len <- P.decimal
  P.char 'x'
  times <- P.decimal
  P.char ')'
  cs <- P.count len P.anyChar
  return $ T.pack $ concat $ replicate times cs

uncompress :: P.Parser T.Text
uncompress = do
  s <- P.many' (compressed <|> uncompressed)
  return $ T.concat s

-- For Part II, we only calculate the length
uncompressedLength :: P.Parser Int
uncompressedLength = do
  -- no P.takeWhile1
  c1 <- P.anyChar
  cs <- P.takeWhile (/= '(')
  return $ (T.length cs) + 1

compressedLength :: P.Parser Int
compressedLength = do
  P.char '('
  len <- P.decimal
  P.char 'x'
  times <- P.decimal
  P.char ')'
  cs <- P.count len P.anyChar
  let (Right internalLength) = P.parseOnly uncompressLength $ T.pack cs
  return $ internalLength * times

uncompressLength :: P.Parser Int
uncompressLength = do
  s <- P.many' (compressedLength <|> uncompressedLength)
  return $ sum s


main = do
  c <- TIO.getLine
  let (Right s) = P.parseOnly uncompress c
  print $ T.length s

  print $ P.parseOnly uncompressLength c
