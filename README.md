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
    weight  ::Int64            # Item weight
    profit  ::Int64            # Item profit
end

struct KnapData
    capacity::Int64            # Knapsack capacity
    items   ::Vector{KnapItem} # Items
end
```

Then, there are four available functions, which take a `KnapData` and return the optimal value and an `Array` with the selected items:

```julia
# Solves KP using a naïve dynamic programming
function solveKnapNaive(data::KnapsackData)
# Solves KP using a binary programming model
function solveKnapModel(data::KnapsackData, optimizer)
# Solves KP using Pisinger's expanding core algorithm
function solveKnapExpCore(data::KnapsackData)
# Solves KP using a simple heuristic
function solveKnapHeur(data::KnapsackData)
```
Function `solveKnapModel` uses [JuMP](https://jump.dev/), and the user must pass the optimizer.

For example, given a `KnapData` instance `data`:
```julia
optimal, selected = solveKnapNaive(data)
optimal, selected = solveKnapModel(data, GLPK.Optimizer)
optimal, selected = solveKnapExpCore(data)
value, selected = solveKnapHeur(data)
```

### Instance generator

The package is able to generate random instances with the following function (based on [this code](http://hjemmesider.diku.dk/~pisinger/generator.c)):
```julia
function genKnap(num_items::Int64, range::Int64 = 1000; type::Symbol = :Uncorrelated, seed::Int64 = 42, num_tests::Int64 = 1000)::KnapData
```
Where:
- `num_items`: Number of items.
- `range`: Maximum weight value.
- `type`: Profit type (`:Uncorrelated`, `:WeakCorrelated`, `:StrongCorrelated`, `:SubsetSum`).
- `seed`: Random seed value.
- `num_tests`: Check source code or original code.

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
-----------------------------------------------------------------------------------------
 MaxV\Items        10        100        500       1000       2000       4000  Algorithm
-----------------------------------------------------------------------------------------
            0.0000034  0.0000241  0.0000964  0.0005683  0.0019213  0.0051835  Naïve
        10  0.0003942  0.0008131  0.0019767  0.0049955  0.0169001  0.0250890  Model
            0.0000170  0.0000605  0.0002518  0.0006652  0.0011306  0.0016287  Exp Core
            0.0000048  0.0000179  0.0000785  0.0002346  0.0003899  0.0008568  Heuristic
-----------------------------------------------------------------------------------------
            0.0000149  0.0000842  0.0007541  0.0035769  0.0176689  0.1049921  Naïve
       100  0.0004224  0.0041956  0.0029547  0.0073759  0.0135483  0.0467603  Model
            0.0000174  0.0000733  0.0002496  0.0004150  0.0007526  0.0015570  Exp Core
            0.0000045  0.0000146  0.0000752  0.0001533  0.0003114  0.0007238  Heuristic
-----------------------------------------------------------------------------------------
            0.0000244  0.0002924  0.0031098  0.0289139  0.1930657  0.9350322  Naïve
       500  0.0004529  0.0025500  0.0061417  0.0155825  0.0355573  0.0986456  Model
            0.0000148  0.0000777  0.0003102  0.0006939  0.0011745  0.0031839  Exp Core
            0.0000047  0.0000152  0.0000683  0.0001718  0.0003763  0.0007297  Heuristic
-----------------------------------------------------------------------------------------
            0.0000857  0.0008994  0.0185047  0.0876981  0.4879295  2.2950974  Naïve
      1000  0.0004184  0.0013805  0.0048302  0.0129863  0.0634582  0.1165906  Model
            0.0000155  0.0001010  0.0003739  0.0006593  0.0025599  0.0021752  Exp Core
            0.0000042  0.0000169  0.0000970  0.0001447  0.0003395  0.0007946  Heuristic
-----------------------------------------------------------------------------------------
            0.0003921  0.0035048  0.0688649  0.2166673  0.8799062  5.8831394  Naïve
      2000  0.0006084  0.0013985  0.0078496  0.0173286  0.0484470  0.2100753  Model
            0.0000180  0.0001040  0.0009026  0.0007541  0.0024153  0.0039622  Exp Core
            0.0000049  0.0000203  0.0000740  0.0001503  0.0003156  0.0007581  Heuristic
-----------------------------------------------------------------------------------------
```

## Related links

- [David Pisinger's optimization codes](http://hjemmesider.diku.dk/~pisinger/codes.html)

## Other packages

- [BPPLib.jl](https://github.com/rafaelmartinelli/BPPLib.jl): Bin Packing Problem and Cutting Stock Problem Lib
- [GAPLib.jl](https://github.com/rafaelmartinelli/GAPLib.jl): Generalized Assignment Problem Lib
- [CFLPLib.jl](https://github.com/rafaelmartinelli/CFLPLib.jl): Capacitated Facility Location Problem Lib
- [CARPData.jl](https://github.com/rafaelmartinelli/CARPData.jl): Capacitated Arc Routing Problem Lib
