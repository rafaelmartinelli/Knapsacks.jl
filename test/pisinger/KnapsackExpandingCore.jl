using KnapsackLib
using GLPK

for x = 1:10
    # weights = [10, 10, 6, 4, 2]
    # profits = [7, 10, 7, 2, 7]
    # capacity = 16
    n = 1000
    weights = rand(1:100, n)
    profits = rand(1:100, n)
    items = [ KnapsackItem(weights[i], profits[i]) for i in 1:n ]
    sort!(items, by = x -> x.profit / x.weight, rev = true)
    capacity = sum(weights) ÷ 2

    data = KnapsackData(capacity, items)
    @time solution1 = solveKnapsackDinProg(data)
    @time solution2 = solveKnapsackModel(data, GLPK.Optimizer)
    @time solution3 = solveKnapsackExpCore(data)

    val1 = sum(data.items[j].profit for j in solution1)
    val2 = sum(data.items[j].profit for j in solution2)
    val31 = sum(data.items[j].profit for j in solution3[1])
    val32 = solution3[2]

    w1 = sum(data.items[j].weight for j in solution1)
    w2 = sum(data.items[j].weight for j in solution2)
    w3 = sum(data.items[j].weight for j in solution3[1])

    print(val1, " (", w1, ") x ", val2, " (", w2, ") x ")
    println(val31, ", ", val32, " (", w3, ")")

    if val1 != val2 || val2 != val31 || val31 != val32
        println(items)
        println(capacity)
        println(solution1)
        println(solution2)
        println(solution3)
        break
    end
end
