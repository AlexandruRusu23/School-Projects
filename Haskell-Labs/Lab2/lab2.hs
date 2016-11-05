-- Declarative Programming
-- Lab 2
--

import Data.Char
import Data.List
import Test.QuickCheck



-- 1. halveEvens

-- List-comprehension version
halveEvens :: [Int] -> [Int]
halveEvens xs = [div x 2 | x <- xs, even x]

-- Recursive version
halveEvensRec :: [Int] -> [Int]
halveEvensRec [] = []
halveEvensRec (x:xs) 
  | even x = div x 2 : halveEvensRec xs 
  | otherwise = halveEvensRec xs

-- Mutual test
prop_halveEvens :: [Int] -> Bool
prop_halveEvens xs = halveEvens xs == halveEvensRec xs



-- 2. inRange

-- List-comprehension version
inRange :: Int -> Int -> [Int] -> [Int]
inRange lo hi xs = [x | x <- xs, x <= hi && x >= lo]

-- Recursive version
inRangeRec :: Int -> Int -> [Int] -> [Int]
inRangeRec lo hi [] = []
inRangeRec lo hi (x:xs) 
  | (x <= hi && x >= lo) = x : inRangeRec lo hi xs 
  | otherwise = inRangeRec lo hi xs

-- Mutual test
prop_inRange :: Int -> Int -> [Int] -> Bool
prop_inRange lo hi xs = inRange lo hi xs == inRangeRec lo hi xs



-- 3. sumPositives: sum up all the positive numbers in a list

-- List-comprehension version
countPositives :: [Int] -> Int
countPositives xs = length [x | x <- xs, x > 0]

-- Recursive version
countPositivesRec :: [Int] -> Int
countPositivesRec [] = 0
countPositivesRec (x:xs) 
  | (x > 0) = 1 + countPositivesRec xs 
  | otherwise = countPositivesRec xs

-- Mutual test
prop_countPositives :: [Int] -> Bool
prop_countPositives xs =  countPositives xs == countPositivesRec xs 



-- 4. pennypincher

-- Helper function
discount :: Int -> Int
discount x = round(fromIntegral x/100 - (fromIntegral x/100)/10)

-- List-comprehension version
pennypincher :: [Int] -> Int
pennypincher xs = sum [(discount x)*100 | x <- xs, discount x <= 199]

-- Recursive version
pennypincherRec :: [Int] -> Int
pennypincherRec [] = 0
pennypincherRec (x:xs)
  | discount x <= 199 = (discount x)*100 + pennypincherRec xs
  | otherwise = pennypincherRec xs

-- Mutual test
prop_pennypincher :: [Int] -> Bool
prop_pennypincher xs = pennypincher xs == pennypincherRec xs



-- 5. sumDigits

-- List-comprehension version
multDigits :: String -> Int
multDigits str = product [ digitToInt x | x <- str, isDigit x ]

-- Recursive version
multDigitsRec :: String -> Int
multDigitsRec [] = 1
multDigitsRec (x:str) 
  | isDigit x = digitToInt x * multDigitsRec str 
  | otherwise = 1 * multDigitsRec str

-- Mutual test
prop_multDigits :: String -> Bool
prop_multDigits str = multDigits str == multDigitsRec str



-- 6. capitalise

-- List-comprehension version
capitalise :: String -> String
capitalise "" = ""
capitalise (x:str) = toUpper x : [toLower x | x <- str]

-- Recursive version
toLowerFunc :: String -> String
toLowerFunc [] = []
toLowerFunc (x:xs) = (toLower x) : toLowerFunc xs
capitaliseRec :: String -> String
capitaliseRec [] = []
capitaliseRec (x:xs) = toUpper x : toLowerFunc xs

-- Mutual test
prop_capitalise :: String -> Bool
prop_capitalise str = capitalise str == capitaliseRec str



-- 7. title

-- aux Funct
correctForm :: String -> String
correctForm x
  | length x >= 4 = capitalise x
  | otherwise = toLowerFunc x

-- List-comprehension version
title :: [String] -> [String]
title [] = []
title (x:xs) = capitalise x : [correctForm w | w <- xs] 

-- Recursive version
titleRec :: [String] -> [String]
titleRec [] = []
titleRec (str:vectStr) = capitaliseRec str : correctRec vectStr
  where correctRec [] = [] 
        correctRec (w:ws) = correctForm w : correctRec ws

-- mutual test
prop_title :: [String] -> Bool
prop_title str = title str == titleRec str

