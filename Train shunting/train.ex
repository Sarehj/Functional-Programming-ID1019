defmodule Train do

  def take(_, 0) do [] end
  def take([], _) do [] end
  def take([h|t], n) when n > 0 do [h | take(t, n-1)] end

  def drop(train, 0) do train end
  def drop([], _) do [] end
  def drop([_|t], n) when n > 0 do drop(t, n-1) end

  def append([], train) do train end
  def append(train, []) do train end
  def append([h1|t1], train2) do [h1 | append(t1, train2)] end

  def member(train, y) do
    case train do
      [] -> false
      [h|_] when h == y -> true
      [_|t] -> member(t, y)
    end
  end

  def position(train, y) do
    case train do
      [] -> 0
      [h|_] when h == y -> 1
      [_|t] -> position(t, y) + 1
    end
  end

  def split(train, y) do
    {take(train, position(train, y) - 1), drop(train, position(train, y))}
  end



  def main(train, 0) do {0, train, []} end
  def main(train, n) do
    case train do
      [] -> {n, [], []}
      [h|t] ->
        case main(t, n) do
          {0, remain, take} ->
            {0, [h|remain], take}
          {k, remain, take} ->
            {k-1, remain, [h|take]}
        end
    end
  end


  # def position([], _) do 0 end
  # def position([y|_], y) do 1 end
  # def position([_|t], y) do position(t, y) + 1 end


  # # def member([], _) do false end
  # # def member([h|_], h) do true end
  # # def member([_|t], y) do member(t, y) end

 # def main([], n) do {n, [], []} end
  # def main(train, 0) do {0, train, []} end

  # def main([h|t], n) do
  #   case main(t, n) do
  #     {0, remain, take} ->
  #       {0, [h|remain], take}
  #     {k, remain, take} ->
  #       {k - 1, remain, [h|t]}
  #     end
  # end


end
