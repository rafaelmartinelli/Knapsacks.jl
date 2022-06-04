function solveDynamicProgramming(data::Knapsack)
    profits = zeros(Int64, ni(data) + 1, data.capacity + 1)

    for i in 2:ni(data) + 1
        w = data.weights[i - 1]
        p = data.profits[i - 1]

        profits[i, :] = profits[i - 1, :]

        for j in w + 1:data.capacity + 1
            profits[i, j] = max(profits[i, j], profits[i - 1, j - w] + p)
        end
    end

    best = 1
    for j in 2:data.capacity + 1
        if profits[end, j] > profits[end, best]
            best = j
        end
    end

    best_val = profits[end, best]
    solution = Int64[]
    for i in ni(data) + 1:-1:2
        if profits[i, best] != profits[i - 1, best]
            push!(solution, i - 1)
            best -= data.weights[i - 1]
        end
    end
    return best_val, reverse(solution)
end
