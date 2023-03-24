defmodule Tree do

#repesent tree: {:node, value, left, right} => {:node, :b, {:leaf, :c}, {:leaf, :a}}

#a func search on a tree for given number return :yes or :no
def member(_, nil) do :no end
def member(elem, {:leaf, elem}) do :yes end
def member(_, {:leaf, _}) do :no end
def member(elem, {:node, elem, _, _}) do :yes end
def member(elem, {:node, _, left, right}) do
  case member(elem, left) do
    :yes -> :yes
    :no -> member(elem, right)

  end
  end

 ## Order Tree! log(n)
 def member1(_, nil) do :no end
 def member1(elem, {:leaf, elem}) do :yes end
 def member1(_, {:leaf, _}) do :no end
 def member1(elem, {:node, elem, _, _}) do :yes end
 def member1(elem, {:node, e, left, right}) do
  if elem < e do
     member1(elem, left)
  else
     member1(elem, right)
  end
  end



#key-value tree
#a func search on a tree for given key return {:value, value} or :no
def lookup(_, nil) do :no end
def lookup(elem, {:node, elem, value, _, _}) do {:value, value} end
def lookup(elem, {:node, e, _, left, right}) do
  if elem < e do
     lookup(elem, left)
  else
     lookup(elem, right)
  end
  end



## modify an element (replace the new value of key)
def modify(_, _, nil) do :nil end
def modify(key, val, {:node, key, _, left, right}) do
  {:node, key, val, left, right}
end
def modify(key, val, {:node, k, v, left, right}) do
  if key < k do
    {:node, k, v, modify(key, val, left), right}
  else
    {:node, k, v, left, modify(key, val, right)}
  end
  end


# Insert value to key
def insert(key, val, nil) do     ##create new tree
  {:node, key, val, :nil, :nil}
end

def insert(key, val, {:node, k, v, left, right}) do
  if key < k do
    {:node, k, v, insert(key, val, left), right}
  else
    {:node, k, v, left, insert(key, val, right)}
  end
end


# Delete
def delete(key, {:node, key, _, :nil, right}) do right end
def delete(key, {:node, key, _, left, :nil}) do left end
def delete(key, {:node, key, _, left, right}) do
  t = leftmost(right)
  {:node, :noKey, 99, left, right}
end

def delete(key, {:node, k, v, left, right}) do
  if key < k do
    {:node, k, v, delete(key, left), right}
  else
    {:node, k, v, left, delete(key, right)}
  end
end

end
