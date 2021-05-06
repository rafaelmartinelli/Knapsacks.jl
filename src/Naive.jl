function solveKnapNaive(data::KnapData)
    profits = repeat([ -Inf ], length(data.items) + 1, data.capacity + 1)
    profits[:, 1] .= 0.0

    for i in 2:length(data.items) + 1
        w = data.items[i - 1].weight
        p = data.items[i - 1].profit

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
    for i in length(data.items) + 1:-1:2
        if profits[i, best] != profits[i - 1, best]
            push!(solution, i - 1)
            best -= data.items[i - 1].weight
        end
    end
    return best_val, reverse(solution)
end
