struct KnapItem
    weight::Int64
    profit::Int64
end

struct KnapData
    capacity::Int64
    items::Vector{KnapItem}

    function KnapData(capacity::Int64, items::Vector{KnapItem})
        checkConsistency(items)
        new(capacity, items)
    end

    function KnapData(capacity::Int64, weights::Vector{Int64}, profits::Vector{Int64})
        items = [ KnapItem(weights[i], profits[i]) for i in 1:length(weights) ]
        checkConsistency(items)
        new(capacity, items)
    end
end

function Base.show(io::IO, data::KnapData)
    print(io, "Knapsack Data")
    print(io, " ($(length(data.items)) items,")
    print(io, " capacity = $(data.capacity))")
end

function checkConsistency(items::Vector{KnapItem})
    large = false
    limit = isqrt(typemax(Int64))
    negative = false
    for item in items
        large = large || (abs(item.weight) >= limit)
        negative = negative || (item.weight < 0)
    end

    if large @warn "Large numbers may result in an overflow, leading to an undefined behavior." end
    if negative @warn "Negative weights are not allowed, leading to an undefined behavior." end
end
