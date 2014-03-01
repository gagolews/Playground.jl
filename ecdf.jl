# Copyleft (C) 2014, Marek Gagolewski
# http://gagolewski.rexamine.com
# Licensed under the MIT license


include("approxfun.jl")



# empirical distribution function
# returns a function of one variable
function ecdf(x)
  xs = sort(x)
  n = length(x)
  nvals = 1
  xu = xs[1:1]
  nc = ones(Int, 1)

  for i in 2:n
    if xs[i-1] == xs[i]
      nc[nvals] += 1
    else
      nvals += 1
      push!(xu, xs[i])
      push!(nc, nc[nvals-1]+1)
    end
  end

#   println(xu)
#   println(nc./n)
#   println(n)
#   println(nvals)

  # do we want rational numbers in y?
  #approxfun_constant(xu, [nc//n for nc in nc], 0//1, 1//1)
  approxfun_constant(xu, convert(Array{Float64,1}, nc./n), 0.0, 1.0)
end
