defmodule EnvTree do

  def new() do nil end

  # if tree is empty.
  def add(nil, key, value) do
    {:node, key, value, nil, nil}
  end

  # if we found a match, we update the value.
  def add({:node, key, _, left, right}, key, value) do
    {:node, key, value, left, right}
  end

  # Iterate left or right.
  def add({:node, k, v, left, right}, key, value) do
    if key < k do
      {:node, k, v, add(left, key, value), right}
    else
      {:node, k, v, left, add(right, key, value)}
    end
  end

  def lookup(nil, _) do nil end
  def lookup({:node, key, value, _, _}, key) do {key, value} end
  def lookup({:node, k, _, left, right}, key) do
    if key < k do
      lookup(left, key)
    else
      lookup(right, key)
    end
  end

  def remove(nil, _) do nil end
  def remove({:node, key, _, nil, right}, key) do right end
  def remove({:node, key, _, left, nil}, key) do left end

  def remove({:node, key, _, left, right}, key) do
    {key, value, rest} = leftmost(right)
    {:node, key, value, left, rest}
  end


  #if key was not found we itterate either left or right.
  def remove({:node, k, v, l, r}, key) do
    if key < k do
      {:node, k, v, remove(l, key), r}
    else
      {:node, k, v, l, remove(r, key)}
    end
  end


  def leftmost({:node, key, value, nil, rest}) do 
    {key, value, rest} 
  end

  def leftmost({:node, k, v, left, right}) do
    {key, value, rest} = leftmost(left)
    {key, value, {:node, k, v, rest, right}}
  end

end
