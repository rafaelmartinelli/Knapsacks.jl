function solveKnapsack(data::Knapsack, algorithm::Symbol = :ExpandingCore; optimizer = nothing)
    if algorithm == :DynamicProgramming
        return solveDynamicProgramming(data)
    elseif algorithm == :BinaryModel
        return solveBinaryModel(data, optimizer)
    elseif algorithm == :ExpandingCore
        return solveExpandingCore(data)
    elseif algorithm == :Heuristic
        return solveHeuristic(data)
    end
end
