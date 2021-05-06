module KnapsackLib

export KnapsackData, KnapsackItem, solveKnapsackModel, solveKnapsackDinProg, solveKnapsackExpCore

using JuMP, LinearAlgebra

const EPS = 1e-7

include("KnapsackData.jl")
include("KnapsackModel.jl")
include("KnapsackDinProg.jl")
include("KnapsackExpandingCore.jl")

end
