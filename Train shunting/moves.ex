defmodule Moves do

  def single({_, 0}, {main, one, two}) do {main, one, two} end
  def single({track, n}, {main, one, two}) do
    case track do
      :one ->
        cond do
          n > 0 ->
          {0, remain, take} = Train.main(main, n)
          {remain, Train.append(take, one), two}

        n < 0 ->
          take = Train.take(one, -n)
          {Train.append(main, take), Train.drop(one, -n), two}
        end

      :two ->
        cond do
          n > 0 ->
          {0, remain, take} = Train.main(main, n)
          {remain, one, Train.append(take, two)}

          n < 0 ->
          take = Train.take(two, -n)
          {Train.append(main, take), one, Train.drop(two, -n)}
        end
    end
  end

  def sequence([], state) do [state] end
  def sequence([h|t], state) do
    next_state = single(h, state)
    [state | sequence(t, next_state)]
  end
end


