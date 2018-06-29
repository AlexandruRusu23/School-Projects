module Arbore (Tree,
               adauga,
               cauta,
               ini,
               parcurgere)
where


data Tree a = Leaf
            | Node a (Tree a) (Tree a)
            deriving Show

-- tree for testing
root :: Tree Int
root = (Node 7 (Node 3 (Node 1 Leaf Leaf) (Node 5 Leaf Leaf)) (Node 10 Leaf Leaf))
--        7
--      /   \
--     3     10
--    / \    
--   1   5

adauga :: Ord a => a -> Tree a -> Tree a
adauga val Leaf = (Node val Leaf Leaf)
adauga val (Node x left right)
  | x == val = (Node val left right)
  | val < x = (Node x (adauga val left) right )
  | val > x = (Node x left (adauga val right) )


cauta :: Ord a => a -> Tree a -> Maybe a
cauta val Leaf = Nothing
cauta val (Node x left right)
  | val == x = Just x
  | val < x = cauta val left
  | val > x = cauta val right


ini :: Ord a => [a] -> Tree a
ini xs = foldr adauga Leaf xs

-- parcurgere (ini [1,5,2,8,10,3,11,6,7]) == [1,2,3,5,6,7,8,10,11]
parcurgere :: Tree a -> [a]
parcurgere Leaf = []
parcurgere (Node x left right) = parcurgere left ++ [x] ++ parcurgere right
