{-# LANGUAGE OverloadedStrings #-}
import Site

import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import Data.Attoparsec.Text
import Data.Char
import Data.List

parseRoom :: Parser (T.Text, Int, T.Text)
parseRoom = do
  name <- takeTill isDigit
  id <- decimal
  char '['
  checksum <- takeTill (== ']')
  char ']'

  return (T.pack $ T.unpack name, id, checksum)

calcChecksum :: T.Text -> T.Text
calcChecksum = T.pack . Data.List.take 5 . map snd . sort . map lh . group . sort . (filter (/= '-')) . T.unpack
  where lh l = (-length l, head l)

isRealRoom :: T.Text -> Int
isRealRoom s = if checksum == calculatedChecksum
               then id
               else 0
  where Right (name, id, checksum) = parseOnly parseRoom s
        calculatedChecksum = calcChecksum name

realName :: T.Text -> T.Text
realName s = T.concat [T.map doShift name, T.pack $ show id]
  where Right (name, id, checksum) = parseOnly parseRoom s
        doShift :: Char -> Char
        --doShift = chr . (+97) . ((flip mod) 26) . (+ id) . (- 97) . ord
        doShift '-' = ' '
        doShift c = chr ((ord c - 97 + id) `mod` 26 + 97)

main = do
  c <- TIO.getContents
  print $ sum $ map isRealRoom $ T.lines c

  TIO.putStrLn $ T.intercalate "\n" $ map realName $ T.lines c
  print $ realName "qzmt-zixmtkozy-ivhz-343[fdaf]"
