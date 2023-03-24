defmodule Deriv do

  @type literal() :: {:num, number() }
                   | {:var, atom()}


  @type expr() :: {:add, expr(), expr()}
                | {:mul, expr(), expr()}
                | {:div, expr(), expr()}
                | {:exp, expr(), literal()} #power(x,2) => x^2
                | {:sin, expr()}
                | {:cos, expr()}
                | {:sqrt, expr()}
                | literal()


#x^2+2*x+3  
def test() do
  add = {:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 3}}
  d = deriv(add, :x)
  c = calc(d, :x, 5)
  s = simplify(c)
  p = pprint(s)  #print in string format


  IO.write("expression: #{pprint(add)}\n")
  IO.write("derivative: #{pprint(d)}\n")
  IO.write("simplify: #{pprint(s)}\n")
  IO.write("calculate: #{pprint(c)}\n")
end

def test2() do
  e = {:add, {:mul, {:num,2}, {:exp, {:var, :x}, {:num, 2}}},
      {:add, {:mul, {:num,4}, {:var, :x}}, {:num, 5} }}
  d = deriv(e, :x)
  c = calc(d, :x, 5) #calculate the value if x=5
  s = simplify(c)



  IO.write("expression: #{pprint(e)}\n")
  IO.write("derivative: #{pprint(d)}\n")
  IO.write("simplify: #{pprint(s)}\n")
  IO.write("calculate: #{pprint(c)}\n")
end

def test3() do
  test =
    {:add, {:mul, {:num, 4}, {:exp, {:var, :x}, {:num, 2}}},
     {:add, {:mul, {:num, 3}, {:var, :x}}, {:num, 42}}}

  der = deriv(test, :x)
  c = calc(der, :x, 5)
  simpl = simplify(c)


  IO.write("expression: #{pprint(test)}\n")
  IO.write("derivative: #{pprint(der)}\n")
  IO.write("simplified: #{pprint(simpl)}\n")
  IO.write("calculate: #{pprint(c)}\n")
end

def test4() do
  test =
    {:div, {:num, 1}, {:var, :x}}

  test2 =
    {:div, {:var, :x}, {:add, {:var, :x},{:num, 2}}}

  der = deriv(test, :x)
  sd = simplify(der)
  c = calc(der, :x, 5)
  simpl = simplify(c)

  der2 = deriv(test2, :x)
  sd2 = simplify(der2)
  c2 = calc(der2, :x, 2)
  simpl2 = simplify(c2)

  IO.write("expression: #{pprint(test2)}\n")
  IO.write("derivative: #{pprint(der2)}\n")
  IO.write("simplified: #{pprint(sd2)}\n")
  IO.write("calculate: #{pprint(c2)}\n")
  IO.write("simplified Answer: #{pprint(simpl2)}\n")
end


def test5() do
  test =
    {:sin, {:var, :x}}

  der = deriv(test, :x)
  c = calc(der, :x, 1)
  simpl = simplify(c)

  IO.write("expression: #{pprint(test)}\n")
  IO.write("derivative: #{pprint(der)}\n")
  IO.write("simplified: #{pprint(simpl)}\n")
  IO.write("calculate: #{pprint(c)}\n")
end


def test6() do
  test =
    {:sqrt, {:var, :x}}

  der = deriv(test, :x)
  c = calc(der, :x, 4)
  simpl = simplify(c)

  IO.write("expression: #{pprint(test)}\n")
  IO.write("derivative: #{pprint(der)}\n")
  IO.write("simplified: #{pprint(simpl)}\n")
  IO.write("calculate: #{pprint(c)}\n")
end


def deriv({:num, _}, _) do {:num, 0} end  #d/dv C = 0
def deriv({:var, v}, v) do {:num, 1} end  #d/dv V= 1
def deriv({:var, _}, _) do {:num, 0} end 

def deriv({:add, e1, e2}, v) do
   {:add, deriv(e1, v), deriv(e2, v)} end

def deriv({:mul, e1, e2}, v) do
  {:add, {:mul, deriv(e1, v), e2}, {:mul, deriv(e2, v), e1}} end

def deriv({:exp, e, {:num, n}}, v) do
 {:mul, {:mul, {:num,n}, {:exp, e, {:num, n-1}}} ,
  deriv(e,v)}
end



#x^n
def deriv({:exp, e , {:var, n}}, v) do
  {:mul,
  {:mul, {:var, n}, {:exp, e, {:add, {:var, n}, {:num, -1}}}},
  deriv(e,v)}
 end

#1/x or division
def deriv({:div, e1, e2}, v) do
{:div,
{:add,
{:mul, e2, deriv(e1, v)},
{:mul, {:num, -1}, {:mul, e1, deriv(e2, v)}}},
{:exp, e2, {:num, 2}}
}
end

#sin
def deriv({:sin, e}, v) do
 {:mul, deriv(e,v), {:cos, e} } end

#cos
def deriv({:cos, e}, v) do
  {:mul, deriv(e,v), {:sin, e} } end

# square route
def deriv({:sqrt, e}, v) do
{:div,
deriv(e, v),
{:mul, {:num, 2}, {:sqrt, e}}}
end

#ln
def deriv({:ln, e}, v) do
  {:div, deriv(e,v), e}
end


def simplify({:num, n}) do {:num, n} end
def simplify({:var, v}) do {:var, v} end

def simplify({:add, e1, e2}) do
  simplify_add(simplify(e1), simplify(e2)) end
def simplify({:mul, e1, e2}) do
  simplify_mul(simplify(e1), simplify(e2)) end
def simplify({:exp, e, n}) do
  simplify_exp(simplify(e), simplify(n)) end


def simplify({:div, e1, e2}) do
  simplify_div(simplify(e1), simplify(e2)) end

def simplify({:sin, e1}) do
  simplify_sin(simplify(e1)) end
def simplify({:cos, e1}) do
  simplify_cos(simplify(e1)) end

def simplify({:sqrt, e1}) do
  simplify_sqrt(simplify(e1)) end


def simplify_add({:num, 0}, e2) do e2 end
def simplify_add(e1, {:num, 0}) do e1 end
def simplify_add({:num, n1}, {:num, n2}) do {:num, n1+n2} end
def simplify_add({:var, v}, {:var, v}) do {:mul, {:num, 2}, {:var, v}} end
def simplify_add(e1, e2) do {:add, e1, e2} end



def simplify_mul({:num, 0}, _) do {:num, 0} end
def simplify_mul(_, {:num, 0}) do {:num, 0} end
def simplify_mul({:num, 1}, e2) do e2 end
def simplify_mul(e1, {:num, 1}) do e1 end
def simplify_mul({:num, n1}, {:num, n2}) do {:num, n1*n2} end

def simplify_mul({:num, n1}, {:mul, {:num, n2}, e}) do {:mul, {:num, n1*n2 }, e} end
def simplify_mul({:num, n1}, {:mul, e, {:num, n2}}) do {:mul, {:num, n1*n2 }, e} end
def simplify_mul({:mul, {:num, n2}, e}, {:num, n1}) do {:mul, {:num, n1*n2 }, e} end
def simplify_mul({:mul, e, {:num, n2}}, {:num, n1}) do {:mul, {:num, n1*n2 }, e} end


def simplify_mul({:var, v}, {:var, v}) do {:mul, {:var, v}, {:var, v}} end
def simplify_mul(e1, e2) do {:mul, e1, e2} end


def simplify_exp({:num, 0}, e2) do {:num, 0} end
def simplify_exp({:num, 1}, e2) do {:num, 1} end
def simplify_exp(e1, {:num, 1}) do e1 end
def simplify_exp(_, {:num, 0}) do {:num, 1} end
def simplify_exp({:num, n1}, {:num, n2}) do {:num, :math.pow(n1,n2)} end

def simplify_exp(e1, e2) do {:exp, e1, e2} end



def simplify_div({:num, 0}, _) do {:num, 0} end
def simplify_div(e1, {:num, 1}) do e1 end
def simplify_div(_, {:num, 0}) do :error end
def simplify_div({:num, n1}, {:num, n2}) do {:num, n1/n2} end
def simplify_div({:var, v}, {:var, v}) do {:num, 1} end
def simplify_div(e1, e2) do {:div, e1, e2} end

def simplify_sin({:num, 0}) do {:num, 0} end
def simplify_sin({:num, n}) do {:num, :math.sin(n)} end
def simplify_sin(e1) do {:sin, e1} end
def simplify_cos({:num, 0}) do {:num, 1} end
def simplify_cos({:num, n}) do {:num, :math.cos(n)} end
def simplify_cos(e1) do {:cos, e1} end

def simplify_sqrt({:num, 0}) do {:num, 0} end
def simplify_sqrt({:num, 1}) do {:num, 1} end
def simplify_sqrt({:num, n}) do {:num, :math.sqrt(n)} end
def simplify_sqrt(e1) do {:sqrt, e1} end


def pprint({:num, n}) do "#{n}" end
def pprint({:var, v}) do "#{v}" end
def pprint({:add, e1, e2}) do "(#{pprint(e1)} + #{pprint(e2)})" end
def pprint({:mul, e1, e2}) do "(#{pprint(e1)} * #{pprint(e2)})" end
def pprint({:exp, e, n}) do "(#{pprint(e)} ^ #{pprint(n)})" end
def pprint({:div, e1, e2}) do "(#{pprint(e1)} / #{pprint(e2)})" end
def pprint({:sin, e}) do "sin(#{pprint(e)})" end
def pprint({:cos, e}) do "cos(#{pprint(e)})" end
def pprint({:sqrt, e}) do "/sq(#{pprint(e)})" end


def calc({:num, n}, _, _) do {:num, n} end
def calc({:var, v}, v, n) do {:num, n} end
def calc({:var, v}, _, _) do {:var, v} end

def calc({:add, e1, e2}, v, n) do
  {:add, calc(e1, v, n), calc(e2, v, n)} end

def calc({:mul, e1, e2}, v, n) do
 {:mul, calc(e1, v, n), calc(e2, v, n)} end

def calc({:exp, e, {:num, n1}}, v, n) do
  {:exp, calc(e, v, n), {:num, n1}}
end

def calc({:div, e1, e2}, v, n) do
  {:div, calc(e1, v, n), calc(e2, v, n)} end

def calc({:sin, e}, v, n) do
  {:sin, calc(e, v, n)} end
def calc({:cos, e}, v, n) do
  {:cos, calc(e, v, n)} end

def calc({:sqrt, e}, v, n) do
  {:sqrt, calc(e, v, n)} end

end
