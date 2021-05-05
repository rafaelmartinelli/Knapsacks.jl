module KnapsackLib

export KnapsackData, solveKnapsackModel, solveKnapsackDinProg

using JuMP

const EPS = 1e-7

include("KnapsackData.jl")
include("KnapsackModel.jl")
include("KnapsackDinProg.jl")

end
