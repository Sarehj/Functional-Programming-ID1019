defmodule Moves do
  def find([], []) do [] end
  def find(xs, [y | ys]) do
    {hs, ts} = Train.split(xs, y)
    moves = [
        {:one, length(ts) + 1},
        {:two, length(hs)},
        {:one, -(length(ts) + 1)},
        {:two, -length(hs)} |
        find(Train.append(hs, ts), ys)
    ]
  end

  def few([], []) do [] end
  def few([y | xs], [y | ys]) do few(xs, ys) end
  def few(xs, [y | ys]) do
    {hs, ts} = Train.split(xs, y)
    [
      {:one, length(ts) + 1},
      {:two, length(hs)},
      {:one, -(length(ts) + 1)},
      {:two, -length(hs)} |
      few(Train.append(hs, ts), ys)
    ]
  end

  def rules([]) do [] end
  def rules([{:one, n} | [{:one, m} | t]]) do
    rules([{:one, n + m} | rules(t)])
  end

  def rules([{:two, n} | [{:two, m} | t]]) do
    rules([{:two, n + m} | rules(t)])
  end

  def rules([{:one, 0} | t]) do rules(t) end
  def rules([{:two, 0} | t]) do rules(t) end
  def rules([h | []]) do [h] end
  def rules(list) do list end

  
  def compress(moves) do
    m = rules(moves)
    if m == moves do
      moves
    else
      compress(m)
    end
  end
end