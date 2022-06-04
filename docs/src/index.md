```@meta
CurrentModule = Knapsacks
```

# Knapsacks.jl

This package solves Knapsack Problems (KPs) using different algorithms.

## Usage

First, it defines the `Knapsack` type:

```julia
struct Knapsack
    capacity::Int64            # Knapsack capacity
    weights ::Vector{Int64}    # Items' weights
    profits ::Vector{Int64}    # Items' profits
end
```

Then, there are four available solvers, called from a single function which takes a `Knapsack`, and returns the optimal/best value and an `Array` with the selected items:

```julia
function solveKnapsack(data::KnapsackData, algorithm::Symbol = :ExpandingCore; optimizer = nothing)
```

Where `algorithm` must be one of the following:

- `DynammicProgramming`: Solves KP using a naïve dynamic programming.
- `BinaryModel`: Solves KP using a binary programming model.
- `ExpandingCore`: Solves KP using Pisinger's expanding core algorithm.
- `Heuristic`: Solves KP using a simple heuristic.

Algorithm `BinaryModel` uses [JuMP](https://jump.dev/), and the user must pass the optimizer.

For example, given a `Knapsack` instance `data`:

```julia
optimal, selected = solveKnapsack(data, :DynammicProgramming)
optimal, selected = solveKnapsack(data, :BinaryModel; optimizer = GLPK.Optimizer)
optimal, selected = solveKnapsack(data, :ExpandingCore)
value, selected = solveKnapsack(data, :Heuristic)
```

## Instance generator

The package is able to generate random instances with the following function (based on [this code](http://hjemmesider.diku.dk/~pisinger/generator.c)):

```julia
function generateKnapsack(num_items::Int64, range::Int64 = 1000; type::Symbol = :Uncorrelated, seed::Int64 = 42, num_tests::Int64 = 1000)::Knapsack
```

Where:

- `num_items`: Number of items.
- `range`: Maximum weight value.
- `type`: Profit type (`:Uncorrelated`, `:WeakCorrelated`, `:StrongCorrelated`, `:SubsetSum`).
- `seed`: Random seed value.
- `num_tests`: Check source code or original code.

## Installation

This package is *not* yet a registered Julia Package.
You can install Knapsacks through the Julia package manager.
Open Julia's interactive session (REPL) and type:

```julia
] add https://github.com/rafaelmartinelli/Knapsacks.jl
```

## Benchmark

Benchmark results (time in seconds) for different maximum values for weights and profits, number of items and algorithms. Average times for 10 runs and using `@timed` (`BinaryModel` using `GLPK.jl`).

```text
--------------------------------------------------------------------------------------------------
 MaxV\Items        10        100        500       1000       2000       4000  Algorithm
--------------------------------------------------------------------------------------------------
            0.0000034  0.0000241  0.0000964  0.0005683  0.0019213  0.0051835  DynammicProgramming
        10  0.0003942  0.0008131  0.0019767  0.0049955  0.0169001  0.0250890  BinaryModel
            0.0000170  0.0000605  0.0002518  0.0006652  0.0011306  0.0016287  ExpandingCore
            0.0000048  0.0000179  0.0000785  0.0002346  0.0003899  0.0008568  Heuristic
--------------------------------------------------------------------------------------------------
            0.0000149  0.0000842  0.0007541  0.0035769  0.0176689  0.1049921  DynammicProgramming
       100  0.0004224  0.0041956  0.0029547  0.0073759  0.0135483  0.0467603  BinaryModel
            0.0000174  0.0000733  0.0002496  0.0004150  0.0007526  0.0015570  ExpandingCore
            0.0000045  0.0000146  0.0000752  0.0001533  0.0003114  0.0007238  Heuristic
--------------------------------------------------------------------------------------------------
            0.0000244  0.0002924  0.0031098  0.0289139  0.1930657  0.9350322  DynammicProgramming
       500  0.0004529  0.0025500  0.0061417  0.0155825  0.0355573  0.0986456  BinaryModel
            0.0000148  0.0000777  0.0003102  0.0006939  0.0011745  0.0031839  ExpandingCore
            0.0000047  0.0000152  0.0000683  0.0001718  0.0003763  0.0007297  Heuristic
--------------------------------------------------------------------------------------------------
            0.0000857  0.0008994  0.0185047  0.0876981  0.4879295  2.2950974  DynammicProgramming
      1000  0.0004184  0.0013805  0.0048302  0.0129863  0.0634582  0.1165906  BinaryModel
            0.0000155  0.0001010  0.0003739  0.0006593  0.0025599  0.0021752  ExpandingCore
            0.0000042  0.0000169  0.0000970  0.0001447  0.0003395  0.0007946  Heuristic
--------------------------------------------------------------------------------------------------
            0.0003921  0.0035048  0.0688649  0.2166673  0.8799062  5.8831394  DynammicProgramming
      2000  0.0006084  0.0013985  0.0078496  0.0173286  0.0484470  0.2100753  BinaryModel
            0.0000180  0.0001040  0.0009026  0.0007541  0.0024153  0.0039622  ExpandingCore
            0.0000049  0.0000203  0.0000740  0.0001503  0.0003156  0.0007581  Heuristic
--------------------------------------------------------------------------------------------------
```

## How to cite this package

You can use the [bibtex file](https://github.com/rafaelmartinelli/Knapsacks.jl/blob/main/citation.bib) available in the project.

Don't forget to star our package!

## Related links

- [David Pisinger's optimization codes](http://hjemmesider.diku.dk/~pisinger/codes.html)

```@index
```

```@autodocs
Modules = [Knapsacks]
```
