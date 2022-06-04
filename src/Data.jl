struct Knapsack
    capacity::Int64
    weights::Vector{Int64}
    profits::Vector{Int64}

    function Knapsack(capacity::Int64, weights::Vector{Int64}, profits::Vector{Int64})
        checkConsistency(weights, profits)
        new(capacity, weights, profits)
    end
end

ni(data::Knapsack)::Int64 = length(data.weights)

function Base.show(io::IO, data::Knapsack)
    print(io, "Knapsack Data")
    print(io, " ($(ni(data)) items,")
    print(io, " capacity = $(data.capacity))")
end

function checkConsistency(weights::Vector{Int64}, profits::Vector{Int64})
    large = false
    limit = isqrt(typemax(Int64))
    negative = false
    for i in 1:length(weights)
        large = large || (abs(weights[i]) >= limit)
        negative = negative || (weights[i] < 0) || (profits[i] < 0)
    end

    if large @warn "Large numbers may result in an overflow, leading to an undefined behavior." end
    if negative @warn "Negative weights or profits are not allowed, leading to an undefined behavior." end
end
