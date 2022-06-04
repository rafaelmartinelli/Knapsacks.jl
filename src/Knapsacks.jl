module Knapsacks

export Knapsack, ni, Algorithm
export solveKnapsack, generateKnapsack

using Random, JuMP

const EPS = 1e-7

include("Data.jl")
include("Model.jl")
include("Naive.jl")
include("ExpandingCore.jl")
include("Heuristic.jl")
include("Solver.jl")
include("Generator.jl")

for algorithm in [ :DynamicProgramming, :BinaryModel, :ExpandingCore, :Heuristic ]
    @eval export $(algorithm)
end

for generator in [ :Uncorrelated, :WeakCorrelated, :StrongCorrelated, :SubsetSum ]
    @eval export $(generator)
end

end
