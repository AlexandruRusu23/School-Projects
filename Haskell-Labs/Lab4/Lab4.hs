-- Informatics 1 - Functional Programming 
-- Tutorial 3
--
-- Week 5 - Due: 22/23 Oct.

import Data.Char
import Test.QuickCheck



-- 1. Map
-- a. (4 simboluri)
uppers :: String -> String
uppers = map toUpper

-- b. (7 simboluri)
doubles :: [Int] -> [Int]
doubles = map (*2)

-- c. (10 simboluri)
penceToPounds :: [Int] -> [Float]
penceToPounds = map $ (/100) . fromIntegral

-- d. (11 simboluri)
uppers' :: String -> String
uppers' xs = [toUpper x | x <- xs]

-- (8 simboluri)
prop_uppers :: String -> Bool
prop_uppers xs = uppers xs == uppers' xs



-- 2. Filter
-- a. (4 simboluri)
alphas :: String -> String
alphas = filter isAlpha

-- b. (8 simboluri)
rmChar ::  Char -> String -> String
rmChar c = filter (/= c)

-- c. (8 simboluri)
above :: Int -> [Int] -> [Int]
above x = filter (> x)

-- d. (13 simboluri)
unequals :: [(Int,Int)] -> [(Int,Int)]
unequals = filter $ uncurry (/=) -- 8 simboluri (ca barosanu') ;)

-- e. (15 simboluri)
rmCharComp :: Char -> String -> String
rmCharComp c xs = [x | x <- xs, x /= c] 

-- (11 simboluri)
prop_rmChar :: Char -> String -> Bool
prop_rmChar c xs = rmChar c xs == rmCharComp c xs



-- 3. Comprehensions vs. map & filter
-- a. 
upperChars :: String -> String
upperChars s = [toUpper c | c <- s, isAlpha c]

-- (7 simboluri)
upperChars' :: String -> String
upperChars' = map toUpper . filter isAlpha

prop_upperChars :: String -> Bool
prop_upperChars s = upperChars s == upperChars' s

-- b. 
largeDoubles :: [Int] -> [Int]
largeDoubles xs = [2 * x | x <- xs, x > 3]

-- (13 simboluri)
largeDoubles' :: [Int] -> [Int]
largeDoubles' = map (*2) . filter (>3)

prop_largeDoubles :: [Int] -> Bool
prop_largeDoubles xs = largeDoubles xs == largeDoubles' xs 

-- c.
reverseEven :: [String] -> [String]
reverseEven strs = [reverse s | s <- strs, even (length s)]

-- (11 simboluri)
reverseEven' :: [String] -> [String]
reverseEven' = map reverse . filter ( even.length )

prop_reverseEven :: [String] -> Bool
prop_reverseEven strs = reverseEven strs == reverseEven' strs



-- 4. Foldr
-- a.
productRec :: [Int] -> Int
productRec []     = 1
productRec (x:xs) = x * productRec xs

-- (7 simboluri)
productFold :: [Int] -> Int
productFold = foldr (*) 1

prop_product :: [Int] -> Bool
prop_product xs = productRec xs == productFold xs

-- b.  (16 simboluri)
andRec :: [Bool] -> Bool
andRec [] = True
andRec (x:xs) = x && andRec xs

-- (7 simboluri)
andFold :: [Bool] -> Bool
andFold = foldr (&&) True

prop_and :: [Bool] -> Bool
prop_and xs = andRec xs == andFold xs 

-- c.  (17 simboluri)
concatRec :: [[a]] -> [a]
concatRec [] = []
concatRec (x:xs) = x ++ concatRec xs

-- (8 simboluri)
concatFold :: [[a]] -> [a]
concatFold = foldr (++) []

prop_concat :: [String] -> Bool
prop_concat strs = concatRec strs == concatFold strs

-- d.  (17 simboluri)
rmCharsRec :: String -> String -> String
rmCharsRec [] str1 = str1
rmCharsRec (c:str1) str2= rmCharsRec str1 $ rmChar c str2

-- (6 simboluri)
rmCharsFold :: String -> String -> String
rmCharsFold = flip $ foldr rmChar

prop_rmChars :: String -> String -> Bool
prop_rmChars chars str = rmCharsRec chars str == rmCharsFold chars str



type Matrix = [[Int]]


-- 5
-- a. (10 simboluri)
uniform :: [Int] -> Bool
uniform xs = all (== head xs) xs

-- b. (	 simboluri)
valid :: Matrix -> Bool
valid matrix = rule_1 && rule_2
  where
    rule_1 = not (null matrix) && not (null $ head matrix)
    rule_2 = uniform $ map length matrix

-- 6.
-- a. 18

-- b. 
zipWith' f xs ys = [ f x y | (x, y) <- zip xs ys ]

-- c. 
zipWith'' f xs ys = map (uncurry f) $ zip xs ys

-- 7.  (22 simboluri + 19 simboluri)  cu tot cu tratarea erorilor
plusM :: Matrix -> Matrix -> Matrix
plusM m1 m2 
  | not (valid m1 && valid m2) = error "Matricea nu e valida"
  | length m1 /= length m2 = error "Numar diferit de linii"
  | (length $ head m1) /= (length $ head m2) = error "Numar diferit de coloane"
  | otherwise  = zipWith (zipWith (+)) m1 m2

-- 8. (23 simboluri + 15 simboluri)  cu tot cu tratarea erorilor  
timesM :: Matrix -> Matrix -> Matrix
timesM m1 m2
  | not (valid m1 && valid m2)    = error "Matricea nu e valida"
  | length (head m1) /= length m2 = error "Numar coloane m2 /= numar linii m1"
  | otherwise                     = map m3Row m1
  where m3Row m1_row = map (sum . zipWith (*) m1_row) m2
