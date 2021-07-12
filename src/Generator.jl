function genKnap(num_items::Int64, range::Int64 = 1000; type::Symbol = :Uncorrelated, seed::Int64 = 42, num_tests::Int64 = 1000)::KnapData
    Random.seed!(seed)

    sum = 0
    items = KnapItem[]
    for i in 1:num_items

        weight = rand(1:range)
        sum += weight

        if (type == :Uncorrelated)
            profit = rand(1:range)
        elseif (type == :WeakCorrelated)
            profit = rand(1:(range ÷ 5 + 1)) + weight - range ÷ 10
            if (profit <= 0) profit = 1 end
        elseif (type == :StrongCorrelated)
            profit = weight + 10
        elseif (type == :SubsetSum)
            profit = weight
        else
            error("Wrong profit correlation type! Use :Uncorrelated, :WeakCorrelated, :StrongCorrelated or :SubsetSum.")
        end

        push!(items, KnapItem(weight, profit))
    end

    capacity = (seed * sum) ÷ (num_tests + 1)
    if (capacity <= range) capacity = range + 1 end

    return KnapData(capacity, items)
end
