module KnapsackLib

export KnapData, KnapItem, solveKnapModel, solveKnapNaive, solveKnapExpCore, solveKnapHeur

using JuMP

const EPS = 1e-7

include("Data.jl")
include("Model.jl")
include("Naive.jl")
include("ExpandingCore.jl")
include("Heuristic.jl")

end
