function generateKnapsack(num_items::Int64, range::Int64 = 1000; type::Symbol = :Uncorrelated, seed::Int64 = 42, num_tests::Int64 = 1000)::Knapsack
    Random.seed!(seed)

    sum = 0
    weights = zeros(Int64, num_items)
    profits = zeros(Int64, num_items)
    for i in 1:num_items

        weights[i] = rand(1:range)
        sum += weights[i]

        if (type == :Uncorrelated)
            profits[i] = rand(1:range)
        elseif (type == :WeakCorrelated)
            profits[i] = rand(1:(range ÷ 5 + 1)) + weights[i] - range ÷ 10
            if (profits[i] <= 0) profits[i] = 1 end
        elseif (type == :StrongCorrelated)
            profits[i] = weights[i] + 10
        elseif (type == :SubsetSum)
            profits[i] = weights[i]
        else
            error("Wrong profit correlation type! Use :Uncorrelated, :WeakCorrelated, :StrongCorrelated or :SubsetSum.")
        end
    end

    capacity = (seed * sum) ÷ (num_tests + 1)
    if (capacity <= range) capacity = range + 1 end

    return Knapsack(capacity, weights, profits)
end
