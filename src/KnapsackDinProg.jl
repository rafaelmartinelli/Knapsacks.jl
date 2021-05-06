function solveKnapsackDinProg(data::KnapsackData)
    profits = repeat([ -Inf ], length(data.weights) + 1, data.capacity + 1)
    profits[:, 1] .= 0.0

    for i in 2:length(data.weights) + 1
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

    result = Int64[]
    for i in length(data.weights) + 1:-1:2
        if profits[i, best] != profits[i - 1, best]
            push!(result, i - 1)
            best -= data.weights[i - 1]
        end
    end
    return reverse(result)
end
