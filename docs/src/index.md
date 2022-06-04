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
 MaxV\Items         10        100        500       1000       2000       4000  Algorithm
--------------------------------------------------------------------------------------------------
             0.0000022  0.0000111  0.0000565  0.0001892  0.0007063  0.0026810  DynamicProgramming
         10  0.0001429  0.0003092  0.0009412  0.0019578  0.0039707  0.0122269  BinaryModel
             0.0000072  0.0000293  0.0001384  0.0003038  0.0006792  0.0013258  ExpandingCore
             0.0000016  0.0000052  0.0000235  0.0000478  0.0001008  0.0002182  Heuristic
--------------------------------------------------------------------------------------------------
             0.0000062  0.0000499  0.0003760  0.0011797  0.0110915  0.0434132  DynamicProgramming
        100  0.0001357  0.0004809  0.0017649  0.0040757  0.0093222  0.0269660  BinaryModel
             0.0000095  0.0000600  0.0002152  0.0003791  0.0007064  0.0010730  ExpandingCore
             0.0000013  0.0000050  0.0000192  0.0000409  0.0000928  0.0001957  Heuristic
--------------------------------------------------------------------------------------------------
             0.0000167  0.0001582  0.0013383  0.0115258  0.0674425  0.3561994  DynamicProgramming
        500  0.0001290  0.0006400  0.0017707  0.0056317  0.0174576  0.0483382  BinaryModel
             0.0000090  0.0000473  0.0002074  0.0003911  0.0006959  0.0014079  ExpandingCore
             0.0000013  0.0000044  0.0000191  0.0000417  0.0000866  0.0001854  Heuristic
--------------------------------------------------------------------------------------------------
             0.0000306  0.0003130  0.0063493  0.0296504  0.1574919  0.7645551  DynamicProgramming
       1000  0.0001279  0.0003963  0.0021209  0.0089878  0.0247364  0.0634847  BinaryModel
             0.0000084  0.0000498  0.0002309  0.0004473  0.0010606  0.0015858  ExpandingCore
             0.0000014  0.0000043  0.0000209  0.0000423  0.0000873  0.0001845  Heuristic
--------------------------------------------------------------------------------------------------
             0.0000616  0.0007209  0.0174228  0.0695316  0.3422440  1.6595295  DynamicProgramming
       2000  0.0001297  0.0004131  0.0024877  0.0062686  0.0211603  0.0714104  BinaryModel
             0.0000090  0.0000538  0.0002315  0.0004709  0.0008501  0.0018993  ExpandingCore
             0.0000014  0.0000045  0.0000225  0.0000422  0.0000866  0.0001845  Heuristic
--------------------------------------------------------------------------------------------------
```

Intel(R) Core(TM) i7-8700K CPU @ 3.70GHz, 64GB RAM, using Julia 1.7.2 on Ubuntu 20.04 LTS.

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
