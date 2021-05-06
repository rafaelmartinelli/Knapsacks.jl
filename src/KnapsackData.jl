struct KnapsackData
    capacity::Int64
    weights::Vector{Int64}
    profits::Vector{Float64}
end

function Base.show(io::IO, data::KnapsackData)
    print(io, "Knapsack Data")
    print(io, " ($(length(data.weights)) elements,")
    print(io, " capacity = $(data.capacity))")
end
