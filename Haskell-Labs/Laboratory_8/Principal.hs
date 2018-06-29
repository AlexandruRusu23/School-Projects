module Principal where

import Arbore

main :: IO [Int]
main = do
      l <- getLine
      let x = map read (words l) :: [Int]
      return (parcurgere ( ini x ))