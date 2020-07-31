{-# LANGUAGE OverloadedStrings #-}
import Data.Attoparsec.ByteString.Char8
import Data.List
import qualified Data.ByteString as BS
import qualified Data.ByteString.Char8 as C



type Triple = (Int, Int, Int)
parseTriple :: Parser Triple
parseTriple = do
  a <- signed decimal
  char ','
  b <- signed decimal
  char ','
  c <- signed decimal
  return (a, b, c)


data Particle = Particle { pos :: Triple, vel :: Triple, acc :: Triple } deriving Show
parseParticle :: Parser Particle
parseParticle = do
  string "p=<"
  pos <- parseTriple
  string ">, v=<"
  vel <- parseTriple
  string ">, a=<"
  acc <- parseTriple
  string ">"
  return $ Particle pos vel acc

getParticle :: C.ByteString -> Particle
getParticle s = p
  where Right p = parseOnly parseParticle s

absacc :: Particle -> Int
absacc (Particle { acc = (x,y,z) }) = abs x + abs y + abs z

main = do
  c <- BS.getContents
  let lines = init $ C.split '\n' c
      particles = map getParticle $ lines
      absaccs = map absacc particles
      minacc = minimum absaccs
  print $ elemIndex minacc absaccs
