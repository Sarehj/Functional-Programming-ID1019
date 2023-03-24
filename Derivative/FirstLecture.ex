defmodule FirstTest do
  def add5(x) do 
    x+5
  end

  def prod(x,y) do
  if x==0 do 0 
  else
      prod(x-1, y) +y
  end
end    

  def fib(n) do
    case n do
      0 -> 0
      1 -> 1
      _ -> fib(n-1) + fib(n-2)
        
    end
  end

# tuples
  def calc(rom) do
    case rom do
    {a, b, c, d} ->
      rom(a) + rom(b) + rom(c) + rom(d)
     _ -> :error
  end
end  


end