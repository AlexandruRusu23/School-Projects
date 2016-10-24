-- Declarative Programming
-- Lab 3
--


import Data.Char
import Data.List
import Test.QuickCheck


-- 1.
rotate :: Int -> [Char] -> [Char]
rotate = undefined

-- 2.
prop_rotate :: Int -> String -> Bool
prop_rotate k str = rotate (l - m) (rotate m str) == str
                        where l = length str
                              m = if l == 0 then 0 else k `mod` l

-- 3. 
makeKey :: Int -> [(Char, Char)]
makeKey = undefined

-- 4.
lookUp :: Char -> [(Char, Char)] -> Char
lookUp = undefined

-- 5.
encipher :: Int -> Char -> Char
encipher = undefined

-- 6.
normalize :: String -> String
normalize = undefined

-- 7.
encipherStr :: Int -> String -> String
encipherStr = undefined

-- 8.
reverseKey :: [(Char, Char)] -> [(Char, Char)]
reverseKey = undefined

-- 9.
decipher :: Int -> Char -> Char
decipher = undefined

decipherStr :: Int -> String -> String
decipherStr = undefined

-- 10.
prop_cipher :: Int -> String -> Bool
prop_cipher = undefined

-- 11.
contains :: String -> String -> Bool
contains = undefined

-- 12.
candidates :: String -> [(Int, String)]
candidates = undefined

