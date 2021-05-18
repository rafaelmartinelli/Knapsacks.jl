# KnapsackLib.jl

<!-- [![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://rafaelmartinelli.github.io/KnapsackLib.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://rafaelmartinelli.github.io/KnapsackLib.jl/dev) -->
[![Build Status](https://github.com/rafaelmartinelli/KnapsackLib.jl/workflows/CI/badge.svg)](https://github.com/rafaelmartinelli/KnapsackLib.jl/actions)
[![Coverage](https://codecov.io/gh/rafaelmartinelli/KnapsackLib.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/rafaelmartinelli/KnapsackLib.jl)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)

KnapsackLib solves Knapsack Problems (KP) using different algorithms.

## Usage

First, it defines the `KnapItem` and `KnapData` types:

```julia
struct KnapItem
    weight::Int64           # Item weight
    profit::Int64           # Item profit
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

## Installation

KnapsackLib is *not* a registered Julia Package.
You can install KnapsackLib through the Julia package manager.
Open Julia's interactive session (REPL) and type:

```julia
] add https://github.com/rafaelmartinelli/KnapsackLib.jl
```

## Benchmark

Benchmark results (time in seconds) for different maximum values for weights and profits, number of items and algorithms. Average times for 10 runs and using `@timed` (Model with GLPK).

```
------------------------------------------------------------------------------
 MaxV\Items        10         50        100        500       1000  Algorithm
------------------------------------------------------------------------------
            0.0000066  0.0000842  0.0003162  0.0115152  0.0585165  Naïve
        10  0.0005138  0.0006685  0.0011759  0.0063126  0.0173382  Model
            0.0000141  0.0000306  0.0000515  0.0002397  0.0003492  Exp Core
------------------------------------------------------------------------------
            0.0000136  0.0003581  0.0014877  0.0632500  0.3000128  Naïve
        50  0.0004836  0.0007185  0.0018582  0.0129172  0.0106744  Model
            0.0000135  0.0000391  0.0000665  0.0002251  0.0003272  Exp Core
------------------------------------------------------------------------------
            0.0000259  0.0004414  0.0023123  0.1315063  0.7479475  Naïve
       100  0.0005052  0.0010954  0.0015549  0.0113286  0.0343576  Model
            0.0000180  0.0000486  0.0000714  0.0002987  0.0004923  Exp Core
------------------------------------------------------------------------------
```

## Related links

- [David Pisinger's optimization codes](http://hjemmesider.diku.dk/~pisinger/codes.html)

## Other packages

- [BPPLib.jl](https://github.com/rafaelmartinelli/BPPLib.jl): Bin Packing Problem and Cutting Stock Problem Lib
- [GAPLib.jl](https://github.com/rafaelmartinelli/GAPLib.jl): Generalized Assignment Problem Lib
- [CFLPLib.jl](https://github.com/rafaelmartinelli/CFLPLib.jl): Capacitated Facility Location Problem Lib
- [CARPData.jl](https://github.com/rafaelmartinelli/CARPData.jl): Capacitated Arc Routing Problem Lib
