{-# LANGUAGE OverloadedStrings #-}
import Data.Attoparsec.ByteString.Char8
import Control.Applicative
import qualified Data.ByteString as BS


newtype Element = Element (Either [Element] String) deriving Show

parseChar :: Parser String
parseChar = do
  choice [
    char '!' >> anyChar >> return "",
    notChar '>' >>= \c -> return [c]
    ]

parseGarbage :: Parser Element
parseGarbage = do
  char '<'
  g <- many' parseChar
  char '>'
  return $ Element $ Right $ concat g

parseGroup :: Parser Element
parseGroup = do
  char '{'
  g <- sepBy (parseGroup <|> parseGarbage) (char ',')
  char '}'
  return $ Element $ Left g

score :: Int -> Element -> Int
score _ (Element (Right _)) = 0
score rootScore (Element (Left group)) = rootScore + subScore
  where subScore = foldl (+) 0 subScores
        subScores = map (score (rootScore + 1)) group

countGarbage :: Element -> Int
countGarbage (Element (Right g)) = length g
countGarbage (Element (Left group)) = foldl (+) 0 $ map countGarbage group

main = do
  c <- BS.getContents
  let (Right rootGroup) = parseOnly parseGroup c
  print $ score 1 rootGroup
  print $ countGarbage rootGroup
