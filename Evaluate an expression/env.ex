defmodule Eval do
  @type literal() :: {:num, number() }
  | {:var, atom()}
  | {:q, number(), number()}


@type expr() :: {:add, expr(), expr()}
| {:mul, expr(), expr()}
| {:div, expr(), expr()}
| {:sub, expr(), expr()}
| literal()

def env({:var, var}, []) do {:var, var} end
def env({:var, var}, [{{:var, var}, {:num, val}} | _]) do
   {:num, val}
end
def env({:var, var}, [_|t]) do env({:var, var}, t) end
def env([{var, val}]) do [{{:var, var}, {:num, val}}] end
def env([{var, val} | t]) do [{{:var, var}, {:num, val}} | env(t)] end


def eval({:num, num}, _) do {:num, num} end
def eval({:var, var}, env) do env({:var, var}, env) end
def eval({:q, num, denom}, _) do simplify({:q, num, denom}) end

def eval({:add, e1, e2}, env) do
  eval(add(eval(e1, env), eval(e2, env)), env)
end
def eval({:sub, e1, e2}, env) do
  eval(sub(eval(e1, env), eval(e2, env)), env)
end
def eval({:mul, e1, e2}, env) do
  eval(mul(eval(e1, env), eval(e2, env)), env)
end
def eval({:div, e1, e2}, env) do
  division(eval(e1, env), eval(e2, env))
end


def add({:num, n1}, {:num, n2}) do {:num, n1 + n2} end

def add({:q, num1, denom1}, {:q, num2, denom1}) do
  simplify({:q, (num1 + num2), denom1})
end
def add({:q, num1, denom1}, {:q, num2, denom2}) do
  simplify({:q, (num1 * denom2) + (num2 * denom1), denom1 * denom2})
end
def add({:num, n}, {:q, num, denom}) do
  simplify({:q, (n * denom) + num, denom})
end
def add({:q, num, denom}, {:num, n}) do
  simplify({:q, (n * denom) + num, denom})
end



def sub({:num, n1}, {:num, n2}) do {:num, n1 - n2} end

def sub({:q, num1, denom}, {:q, num2, denom}) do
  simplify({:q, (num1 - num2), denom})
end
def sub({:q, num1, denom1}, {:q, num2, denom2}) do
  simplify({:q, (num1 * denom2) - (num2 * denom1), denom1 * denom2})
end
def sub({:num, n}, {:q, num, denom}) do
  simplify({:q, (n * denom) - num, denom})
end
def sub({:q, num, denom}, {:num, n}) do
  simplify({:q, (n * denom) - num, denom})
end



def mul({:num, 0}, _) do {:num, 0} end
def mul(_, {:num, 0}) do {:num, 0} end
def mul({:num, n1}, {:num, n2}) do {:num, n1 * n2} end

def mul({:q, num1, denom1}, {:q, num2, denom2}) do
  simplify({:q, (num1 * num2), (denom1 * denom2)})
end
def mul({:num, n}, {:q, num, denom}) do
  simplify({:q, (n * num), denom})
end
def mul({:q, num, denom}, {:num, n}) do
  simplify({:q, (n * num), denom})
end



def division({:num, 0}, _) do {:num, 0} end
def division(_, {:num, 0}) do :undifined end
def division({:num, n1}, {:num, n2}) do simplify{:q, n1, n2} end

def division({:q, num1, denom1}, {:q, num2, denom2}) do
  simplify({:q, (num1 * denom2), (num2 * denom1)})
end
def division({:num, n}, {:q, num, denom}) do
  simplify({:q, (n * denom), num})
end
def division({:q, num, denom}, {:num, n}) do
  simplify({:q, num, (n * denom)})
end



def simplify({:q, _, 0}) do :undefined end
def simplify({:q, 0, _}) do {:num, 0} end
def simplify({:q, num, denom}) do
  if rem(num, denom) == 0 do
    {:num, div(num,denom)}
  else
    gcd = Integer.gcd(num, denom)
    {:q, div(num, gcd), div(denom,gcd)}
  end
end

end
