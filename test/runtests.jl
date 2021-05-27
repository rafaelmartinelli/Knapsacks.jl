using KnapsackLib
using Test
using GLPK

@testset "DataVec" begin
    data = KnapData(10, [ 2, 3, 4, 5, 6 ], [ 2, 4, 6, 8, 10 ])
    @test_nowarn println(data)
    @test data.capacity == 10
    @test length(data.items) == 5
    @test data.items[4].weight == 5
    @test data.items[3].profit == 6
end

@testset "DataVecEmpty" begin
    data = KnapData(10, Int64[], Int64[])
    @test_nowarn println(data)
    @test data.capacity == 10
    @test length(data.items) == 0
end

@testset "DataIt" begin
    weights = [ 2, 3, 4, 5, 6 ]
    profits = [ 2, 4, 6, 8, 10 ]
    items = [ KnapItem(weights[i], profits[i]) for i in 1:length(weights) ]
    data = KnapData(10, items)
    @test_nowarn println(data)
    @test data.capacity == 10
    @test length(data.items) == 5
    @test data.items[4].weight == 5
    @test data.items[3].profit == 6
end

@testset "DataItEmpty" begin
    data = KnapData(10, KnapItem[])
    @test_nowarn println(data)
    @test data.capacity == 10
    @test length(data.items) == 0
end

@testset "Model" begin
    data = KnapData(10, [ 2, 3, 4, 5, 6 ], [ 2, 4, 5, 6, 10 ])
    val, sol = solveKnapModel(data, GLPK.Optimizer)
    @test sol == [ 3, 5 ]
    @test val == 15
end

@testset "ModelEmpty" begin
    data = KnapData(10, KnapItem[])
    val, sol = solveKnapModel(data, GLPK.Optimizer)
    @test sol == []
    @test val == 0
end

@testset "ModelExceed" begin
    data = KnapData(1, [ 2, 3, 4, 5, 6 ], [ 2, 4, 5, 6, 10 ])
    val, sol = solveKnapModel(data, GLPK.Optimizer)
    @test sol == []
    @test val == 0
end

@testset "Naive" begin
    data = KnapData(10, [ 2, 3, 4, 5, 6 ], [ 2, 4, 5, 6, 10 ])
    val, sol = solveKnapNaive(data)
    @test sol == [ 3, 5 ]
    @test val == 15
end

@testset "NaiveEmpty" begin
    data = KnapData(10, KnapItem[])
    val, sol = solveKnapNaive(data)
    @test sol == []
    @test val == 0
end

@testset "NaiveExceed" begin
    data = KnapData(1, [ 2, 3, 4, 5, 6 ], [ 2, 4, 5, 6, 10 ])
    val, sol = solveKnapNaive(data)
    @test sol == []
    @test val == 0
end

@testset "ExpCore" begin
    data = KnapData(10, [ 2, 3, 4, 5, 6 ], [ 2, 4, 5, 6, 10 ])
    val, sol = solveKnapExpCore(data)
    @test sol == [ 3, 5 ]
    @test val == 15
end

@testset "ExpCoreEmpty" begin
    data = KnapData(10, KnapItem[])
    val, sol = solveKnapExpCore(data)
    @test sol == []
    @test val == 0
end

@testset "ExpCoreExceed" begin
    data = KnapData(1, [ 2, 3, 4, 5, 6 ], [ 2, 4, 5, 6, 10 ])
    val, sol = solveKnapExpCore(data)
    @test sol == []
    @test val == 0
end

@testset "Heur" begin
    data = KnapData(10, [ 2, 3, 4, 5, 6 ], [ 2, 4, 5, 6, 10 ])
    val, sol = solveKnapHeur(data)
    @test sol == [ 1, 4, 2 ]
    @test val == 12
end

@testset "HeurEmpty" begin
    data = KnapData(10, KnapItem[])
    val, sol = solveKnapHeur(data)
    @test sol == []
    @test val == 0
end

@testset "HeurExceed" begin
    data = KnapData(1, [ 2, 3, 4, 5, 6 ], [ 2, 4, 5, 6, 10 ])
    val, sol = solveKnapHeur(data)
    @test sol == []
    @test val == 0
end

@testset "Random" begin
    for k in 1:100
        n = 100
        weights = rand(1:100, n)
        profits = rand(1:100, n)
        capacity = sum(weights) ÷ 2
        data = KnapData(capacity, weights, profits)
        val1, sol1 = solveKnapNaive(data)
        val2, sol2 = solveKnapModel(data, GLPK.Optimizer)
        val3, sol3 = solveKnapNaive(data)
        @test val1 == val2 == val3
    end
end
