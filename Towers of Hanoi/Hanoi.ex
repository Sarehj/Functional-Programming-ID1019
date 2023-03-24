defmodule Hanoi do

  def hanoi(0, _, _, _) do [] end
  def hanoi(n, from, aux, to) do
    hanoi(n - 1, from, to, aux) ++ [{:move, from, to}] ++ 
    hanoi(n - 1, aux, from, to)
  end
  
  def moves(list) do Enum.count(list) end
end