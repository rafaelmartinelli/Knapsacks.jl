struct Label
    item::Int64
    profit::Int64
    weight::Int64
    last::Union{Label, Nothing}
end

function solveKnapsackDinProg(data::KnapsackData)
    profits = zeros(Int64, data.capacity + 1)

    active = Label[]
    next = Label[]
    best = nothing

    for i in 1:length(data.weights)
        weight = data.weights[i]
        profit = data.profits[i]

        push!(active, Label(0, 0, 0, nothing))

        while !isempty(active)
            label = pop!(active)

            new_weight = label.weight + weight
            new_profit = label.profit + profit

            if new_weight <= data.capacity && new_profit > profits[new_weight + 1]
                profits[new_weight + 1] = new_profit

                new_label = Label(i, new_profit, new_weight, label)
                push!(next, new_label)

                if best === nothing || best.profit < new_profit
                    best = new_label
                end
            end
        end

        active = copy(next)
    end

    result = Int64[]
    while best.item != 0
        push!(result, best.item)
        best = best.last
    end
    return reverse(result)
end
