struct KnapItem
    weight::Int64
    profit::Int64
end

struct KnapData
    capacity::Int64
    items::Vector{KnapItem}

    KnapData(capacity::Int64, items::Vector{KnapItem}) = new(capacity, items)
    KnapData(capacity::Int64, weights::Vector{Int64}, profits::Vector{Int64}) = new(capacity, [ KnapItem(weights[i], profits[i]) for i in 1:length(weights) ])
end

function Base.show(io::IO, data::KnapData)
    print(io, "Knapsack Data")
    print(io, " ($(length(data.items)) items,")
    print(io, " capacity = $(data.capacity))")
end
