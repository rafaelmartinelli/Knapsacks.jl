# KnapsackLib

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://rafaelmartinelli.github.io/KnapsackLib.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://rafaelmartinelli.github.io/KnapsackLib.jl/dev)
[![Build Status](https://github.com/rafaelmartinelli/KnapsackLib.jl/workflows/CI/badge.svg)](https://github.com/rafaelmartinelli/KnapsackLib.jl/actions)
[![Coverage](https://codecov.io/gh/rafaelmartinelli/KnapsackLib.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/rafaelmartinelli/KnapsackLib.jl)

This package solves Knapsack Problems (KP), by both Binary Programming and Dynamic Programming. First, it defines the `KnapsackData` type:
```julia
struct KnapsackData
    capacity ::Int64           # Knapsack capacity
    weights  ::Vector{Int64}   # Items' weights
    profits  ::Vector{Float64} # Items' profits
end
```

Then, there are two available functions, which take a `KnapsackData` and return an `Array` with the selected items:
```julia
function solveKnapsackDinProg(data::KnapsackData)
function solveKnapsackModel(data::KnapsackData, optimizer)
```
Function `solveKnapsackModel` uses [JuMP](https://jump.dev/), and the user must pass the optimizer.

For example, given a `KnapsackData` instance `data`:
```julia
selected = solveKnapsackDinProg(data)
selected = solveKnapsackModel(data, GLPK.Optimizer)
```

To install:
```julia
] add https://github.com/rafaelmartinelli/KnapsackLib.jl
```

Related links:
- ...
