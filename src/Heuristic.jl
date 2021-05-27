function solveKnapHeur(data::KnapData)
    perm = sortperm(data.items, by = x -> x.profit / x.weight)

    solution = Int64[]
    best_val = 0
    capacity = data.capacity
    for index in perm
        if data.items[index].weight <= capacity
            push!(solution, index)
            best_val += data.items[index].profit
            capacity -= data.items[index].weight
        end
    end

    return best_val, solution
end
