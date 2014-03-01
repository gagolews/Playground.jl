# Copyleft (C) 2014, Marek Gagolewski
# http://gagolewski.rexamine.com
# Licensed under the MIT license


## t.b.d.
## There is a (possible bug) in Julia Version 0.3.0-prerelease+1491 Commit af339f1*
##
## julia> function f(x); function(); return x::Int64; end; end
## julia> g = f(1)
## julia> [g() for x in 1:5]
## 5-element Array{Any,1}:
## 1
## 1
## 1
## 1
## 1
##
## Thus, llvm fails to auto-guess ret type of g(), which is obvious
## But note that g is an anonymous function, and not a generic one



# returns a stepwise function approximating (xp_i, yp_i), i=1..n
# yleft for x < xp[i]
# yleft for x > xp[end]
# xp must be sorted increasingly (do we really need this)
function approxfun_constant{S<:Real, T<:Real}(xp::Array{S,1}, yp::Array{T,1}, yleft::T, yright::T)
  @assert length(xp) == length(yp)

  for i in 2:length(xp)
    @assert xp[i-1] < xp[i]
  end

  xp::Array{S,1} = copy(xp)
  yp::Array{T,1} = copy(yp)

  function approxfun{R<:Real}(x::R)

    if x < xp[1]
      #@assert typeof(yleft) != Nothing
      return yleft::T
    end

    if x > xp[end]
      #@assert typeof(yright) != Nothing
      return yright::T
    end

    # binary searching
    n = length(xp)
    a::Int = 1
    b::Int = n

    while a < b
      m::Int = div(b+a-1, 2)+1
      if x == xp[m] || (m < n && xp[m] <= x && x < xp[m+1])
        return yp[m]::T
      elseif x < xp[m]
        b = m-1
      else
        a = m
      end
    end

    return yp[a]::T
  end

end
