function solveHeuristic(data::Knapsack)
    factors = [ data.profits[i] / data.weights[i] for i in 1:ni(data) ]
    permutation = sortperm(factors, rev = true)

    solution = Int64[]
    best_val = 0
    capacity = data.capacity
    for i in permutation
        if data.weights[i] <= capacity
            push!(solution, i)
            best_val += data.profits[i]
            capacity -= data.weights[i]
        end
    end

    return best_val, solution
end
