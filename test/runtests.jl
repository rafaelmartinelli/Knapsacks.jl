using Knapsacks
using Test
using GLPK

@testset "DataVec" begin
    data = Knapsack(10, [ 2, 3, 4, 5, 6 ], [ 2, 4, 6, 8, 10 ])
    @test_nowarn println(data)
    @test data.capacity == 10
    @test ni(data) == 5
    @test data.weights[4] == 5
    @test data.profits[3] == 6
end

@testset "DataVecEmpty" begin
    data = Knapsack(10, Int64[], Int64[])
    @test_nowarn println(data)
    @test data.capacity == 10
    @test ni(data) == 0
end

@testset "DataOverflow" begin
    msg = "Large numbers may result in an overflow, leading to an undefined behavior."
    @test_logs (:warn, msg) data = Knapsack(1, [ isqrt(typemax(Int64)) ], [ 1 ])
end

@testset "DataNegative" begin
    msg = "Negative weights or profits are not allowed, leading to an undefined behavior."
    @test_logs (:warn, msg) data = Knapsack(1, [ -1 ], [ 1 ])
    @test_logs (:warn, msg) data = Knapsack(1, [ 1 ], [ -1 ])
end

@testset "Model" begin
    data = Knapsack(10, [ 2, 3, 4, 5, 6 ], [ 2, 4, 5, 6, 10 ])
    val, sol = solveKnapsack(data, :BinaryModel; optimizer = GLPK.Optimizer)
    @test sol == [ 3, 5 ]
    @test val == 15
end

@testset "ModelEmpty" begin
    data = Knapsack(10, Int64[], Int64[])
    val, sol = solveKnapsack(data, :BinaryModel; optimizer = GLPK.Optimizer)
    @test sol == []
    @test val == 0
end

@testset "ModelExceed" begin
    data = Knapsack(1, [ 2, 3, 4, 5, 6 ], [ 2, 4, 5, 6, 10 ])
    val, sol = solveKnapsack(data, :BinaryModel; optimizer = GLPK.Optimizer)
    @test sol == []
    @test val == 0
end

@testset "Naive" begin
    data = Knapsack(10, [ 2, 3, 4, 5, 6 ], [ 2, 4, 5, 6, 10 ])
    val, sol = solveKnapsack(data, :DynamicProgramming)
    @test sol == [ 3, 5 ]
    @test val == 15
end

@testset "NaiveEmpty" begin
    data = Knapsack(10, Int64[], Int64[])
    val, sol = solveKnapsack(data, :DynamicProgramming)
    @test sol == []
    @test val == 0
end

@testset "NaiveExceed" begin
    data = Knapsack(1, [ 2, 3, 4, 5, 6 ], [ 2, 4, 5, 6, 10 ])
    val, sol = solveKnapsack(data, :DynamicProgramming)
    @test sol == []
    @test val == 0
end

@testset "ExpCore" begin
    data = Knapsack(10, [ 2, 3, 4, 5, 6 ], [ 2, 4, 5, 6, 10 ])
    val, sol = solveKnapsack(data, :ExpandingCore)
    @test sol == [ 3, 5 ]
    @test val == 15
end

@testset "ExpCoreEmpty" begin
    data = Knapsack(10, Int64[], Int64[])
    val, sol = solveKnapsack(data, :ExpandingCore)
    @test sol == []
    @test val == 0
end

@testset "ExpCoreExceed" begin
    data = Knapsack(1, [ 2, 3, 4, 5, 6 ], [ 2, 4, 5, 6, 10 ])
    val, sol = solveKnapsack(data, :ExpandingCore)
    @test sol == []
    @test val == 0
end

@testset "Heur" begin
    data = Knapsack(10, [ 2, 3, 4, 5, 6 ], [ 2, 4, 5, 6, 10 ])
    val, sol = solveKnapsack(data, :Heuristic)
    @test sol == [ 5, 2 ]
    @test val == 14
end

@testset "HeurEmpty" begin
    data = Knapsack(10, Int64[], Int64[])
    val, sol = solveKnapsack(data, :Heuristic)
    @test sol == []
    @test val == 0
end

@testset "HeurExceed" begin
    data = Knapsack(1, [ 2, 3, 4, 5, 6 ], [ 2, 4, 5, 6, 10 ])
    val, sol = solveKnapsack(data, :Heuristic)
    @test sol == []
    @test val == 0
end

@testset "Random" begin
    types = [ :Uncorrelated, :WeakCorrelated, :StrongCorrelated, :SubsetSum ]
    for k in 1:100
        n = 100
        data = generateKnapsack(n, n; type = types[k % 4 + 1])
        val1, sol1 = solveKnapsack(data, :DynamicProgramming)
        val2, sol2 = solveKnapsack(data, :BinaryModel; optimizer = GLPK.Optimizer)
        val3, sol3 = solveKnapsack(data, :ExpandingCore)
        @test val1 == val2 == val3
    end
end

@testset "WrongRandom" begin
    @test_throws ErrorException data = generateKnapsack(10, 10; type = :Bogus)
end
