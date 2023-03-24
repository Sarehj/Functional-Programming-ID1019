defmodule Second do

  #append 2 list
  def append([], y) do y end
  def append([h|t], y) do
    z = append(t, y)
    [h|z]
  end

  #multiset(a bag) order is not important!
  def union([], y) do y end
  def union([h|t], y) do
    z = union(t, y)
    [h|z]
  end

  #better way!
  def tailr([], y) do y end
  def tailr([h|t], y) do
    z = [h|y]
    tailr(t, z)
  end

 #Sum
 def sum1([]) do 0 end
 def sum1([h|t]) do
   h + sum1(t)
 end

 def sum2([]) do 0 end
 def sum2([h|t]) do
   s = sum2(t)
   h + s
 end

 #tailr recur way!
 def sum3(list) do sum3(list, 0) end
 def sum3([], s) do s end
 def sum3([h|t], s) do sum3(t, h + s) end



 #select Odd or even element of a list
 def odd([]) do [] end
 def odd([h|t]) do
   if rem(h,2) == 1 do
      [h | odd(t)]
   else
      odd(t)
   end
 end

 def even([]) do [] end
 def even([h|t]) do
   if rem(h,2) == 0 do
      [h | even(t)]
   else
      even(t)
   end
 end

 #print odd and even seperatly

 #is not good way But ... maybe when we a have long list
 def odd_n_even1(list) do
  o = odd(list)
  e = even(list)
  {o, e}
 end

 #better way!
 def odd_n_even2([]) do {[], []} end
 def odd_n_even2([h|t]) do
  {o, e} = odd_n_even2(t)
  if rem(h,2) == 1 do
    {[h|o], e}
   else
    {o, [h|e]}
   end
 end


 #best way (tailr recur)
 def odd_n_even3(list) do odd_n_even3(list, [], []) end
 def odd_n_even3([], odd, even) do {odd, even} end

 def odd_n_even3([h|t], odd, even) do
  if rem(h,2) == 1 do
    odd_n_even3(t, [h|odd], even)
   else
    odd_n_even3(t, odd, [h|even])
   end
 end


 #reverse a list
 def rev([]) do [] end
 def rev([h|t]) do rev(t) ++ [h] end

 #better way!
 def rev1(list) do rev1(list,[]) end
 def rev1([], res) do res end
 def rev1([h|t], res) do rev1(t, [h|res]) end


 #flatten [[1,2], [3,4], [5,6]] -> [1,2,3,4,5,6]
 def flat([]) do [] end
 def flat([h|t]) do h ++ flat(t) end

 #tail version
 def flat1(list) do flat1(list, []) end
 def flat1([], res ) do res end
 def flat1([h|t], res) do flat1(t, res ++ h) end

###############################################################################

 #return the n'th element from a list of three
 def nth(1, [h|_]) do h end
 def nth(2, [_,h|_]) do h end
 def nth(3, [_,_,h]) do h end

 #return the n'th element from a tuple of tree
 def nth_t(1, {h,_,_}) do h end
 def nth_t(2, {_,h,_}) do h end
 def nth_t(3, {_,_,h}) do h end

 #better way! this is just for list, tuple doesn't have.
 #can use elem(index, tuple)
 #a library for list: Enum.at(index(from 0), list)
 def nth_b(1, [h|_]) do h end
 def nth_b(n, [_|t]) do nth_b(n-1, t) end


 #queue (it's a type of list)
 def add(elem, []) do [elem] end
 def add(elem, [h|t]) do [h| add(elem, t)] end

 def remove([]) do :error end
 def remove([elem|rest]) do {:ok, elem, rest} end


 #Another way!
 #{:q, [:a, :b], [:e, :d, :e]}
 def add1({:queue, front, back}, elem) do {:queue, front, [elem|back]} end

 def remove1({:queue, [elem|rest], back}) do
  {:ok, elem, {:queue, rest, back}} end
 def remove1({:queue, [], []}) do :error end
 def remove1({:queue, [], back}) do
  remove1({:queue, reverse(back), []})
end


def reverse(list) do reverse(list, []) end
def reverse([], rev) do rev end
def reverse([h|t], rev) do reverse(t, [h|rev]) end

#  def remove1({:queue, [], back}) do
#    case reverse(back) do
#       [] -> :fail
#       [elem|rest] -> {:ok, elem, {:queue, rest, []}}
#     end
#     end
end
