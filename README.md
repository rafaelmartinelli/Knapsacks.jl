# KnapsackLib.jl

<!-- [![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://rafaelmartinelli.github.io/KnapsackLib.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://rafaelmartinelli.github.io/KnapsackLib.jl/dev) -->
[![Build Status](https://github.com/rafaelmartinelli/KnapsackLib.jl/workflows/CI/badge.svg)](https://github.com/rafaelmartinelli/KnapsackLib.jl/actions)
[![Coverage](https://codecov.io/gh/rafaelmartinelli/KnapsackLib.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/rafaelmartinelli/KnapsackLib.jl)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)

This package solves Knapsack Problems (KP) using different algorithms. First, it defines the `KnapItem` and `KnapData` types:
```julia
struct KnapItem
    weight::Int64           # Item weight
    profit::Number          # Item profit
end

struct KnapData
    capacity::Int64         # Knapsack capacity
    items::Vector{KnapItem} # Items
end
```

Then, there are three available functions, which take a `KnapData` and return the optimal value and an `Array` with the selected items:
```julia
# Solves KP using a naïve dynamic programming
function solveKnapNaive(data::KnapsackData)
# Solves KP using a binary programming model
function solveKnapModel(data::KnapsackData, optimizer)
# Solves KP using Pisinger's expanding core algorithm
function solveKnapExpCore(data::KnapsackData)
```
Function `solveKnapModel` uses [JuMP](https://jump.dev/), and the user must pass the optimizer.

For example, given a `KnapData` instance `data`:
```julia
optimal, selected = solveKnapNaive(data)
optimal, selected = solveKnapModel(data, GLPK.Optimizer)
optimal, selected = solveKnapExpCore(data)
```

Benchmark results (time in seconds) for different maximum values for weights and profits, number of items and algorithms. Average times for 10 runs and using `@timed` (Model with GLPK).

```
------------------------------------------------------------------------------
 MaxV\Items        10         50        100        500       1000  Algorithm
------------------------------------------------------------------------------
            0.0001206  0.0018705  0.0076681  0.2205037  0.8768440  Naïve
        10  0.0014689  0.0008209  0.0017506  0.0110000  0.0418939  Model
            0.0001147  0.0001301  0.0001935  0.0008592  0.0017256  Exp Core
------------------------------------------------------------------------------
            0.0002900  0.0099768  0.0451764  1.4290991  5.9682664  Naïve
        50  0.0005964  0.0013730  0.0027424  0.0201457  0.0322329  Model
            0.0000420  0.0002848  0.0003659  0.0021347  0.0017909  Exp Core
------------------------------------------------------------------------------
            0.0004500  0.0159237  0.0742351  2.8241936 11.7709446  Naïve
       100  0.0004603  0.0013097  0.0020115  0.0163233  0.0423875  Model
            0.0000414  0.0003333  0.0003626  0.0012152  0.0020996  Exp Core
------------------------------------------------------------------------------
```

To install:
```julia
] add https://github.com/rafaelmartinelli/KnapsackLib.jl
```

Related links:
- [David Pisinger's optimization codes](http://hjemmesider.diku.dk/~pisinger/codes.html)
- [Bin Packing and Cutting Stock Lib](https://github.com/rafaelmartinelli/BPPLib.jl)
