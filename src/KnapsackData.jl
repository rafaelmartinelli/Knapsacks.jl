struct KnapsackItem
    weight::Int64
    profit::Number
end

struct KnapsackData
    capacity::Int64
    items::Vector{KnapsackItem}
end

function Base.show(io::IO, data::KnapsackData)
    print(io, "Knapsack Data")
    print(io, " ($(length(data.items)) items,")
    print(io, " capacity = $(data.capacity))")
end
