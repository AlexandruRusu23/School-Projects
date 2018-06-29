-- Declarative Programming
-- Lab 3
--


import Data.Char
import Data.List
import Test.QuickCheck


-- 1.
rotate :: Int -> [Char] -> [Char]
rotate n xs = bs ++ as where (as, bs) = splitAt n xs

-- 2.
prop_rotate :: Int -> String -> Bool
prop_rotate k str = rotate (l - m) (rotate m str) == str
                        where l = length str
                              m = if l == 0 then 0 else k `mod` l

-- 3. 
makeKey :: Int -> [(Char, Char)]
makeKey n = zip ['A'..'Z'] (rotate n ['A'..'Z'])

-- 4.
lookUp :: Char -> [(Char, Char)] -> Char
lookUp c xc = if length l > 0 then head l else c
    where l = [b | (a,b) <- xc, c == a]

-- 5.
encipher :: Int -> Char -> Char
encipher n c = lookUp c $ makeKey n 

-- 6.
normalize :: String -> String
normalize "" = ""
normalize str = [toUpper c | c <- str, isAlpha c || isDigit c]

-- 7.
encipherStr :: Int -> String -> String
encipherStr n str = [ encipher n x | x <- normalize str]

-- 8.
reverseKey :: [(Char, Char)] -> [(Char, Char)]
reverseKey xs = [ (b,a) | (a,b) <- xs ]

-- 9.
decipher :: Int -> Char -> Char
decipher n c = lookUp c $ reverseKey $ makeKey n

decipherStr :: Int -> String -> String
decipherStr n str = [ decipher n c | c <- normalize str ]

-- 10.
prop_cipher :: Int -> String -> Bool
prop_cipher n str = decipherStr n (encipherStr n str) == str

-- 11.
contains :: String -> String -> Bool
contains [] n = null n
contains haystack@(h:hs) n
  | n `isPrefixOf` haystack = True
  | otherwise = contains hs n

-- 12.
candidates :: String -> [(Int, String)]
candidates string = [(n, candidate n) | n <- [1..26], candidate n `contains` "AND" || candidate n `contains` "THE"]
   where candidate n = decipherStr n string
