using KnapsackLib
using Test
using GLPK

@testset "Data" begin
    data = KnapData(10, [ 2, 3, 4, 5, 6 ], [ 2, 4, 6, 8, 10 ])
    @test_nowarn println(data)
    @test data.capacity == 10
    @test length(data.items) == 5
    @test data.items[4].weight == 5
    @test data.items[3].profit == 6
end

@testset "Model" begin
    data = KnapData(10, [ 2, 3, 4, 5, 6 ], [ 2, 4, 5, 6, 10 ])
    val, sol = solveKnapModel(data, GLPK.Optimizer)
    @test sol == [ 3, 5 ]
    @test val == 15
end

@testset "Naive" begin
    data = KnapData(10, [ 2, 3, 4, 5, 6 ], [ 2, 4, 5, 6, 10 ])
    val, sol = solveKnapNaive(data)
    @test sol == [ 3, 5 ]
    @test val == 15
end

@testset "ExpCore" begin
    data = KnapData(10, [ 2, 3, 4, 5, 6 ], [ 2, 4, 5, 6, 10 ])
    val, sol = solveKnapExpCore(data)
    @test sol == [ 3, 5 ]
    @test val == 15
end

@testset "Random" begin
    n = 100
    weights = rand(1:10, n)
    profits = rand(1:10, n)
    capacity = sum(weights) ÷ 2
    data = KnapData(capacity, weights, profits)
    val1, sol1 = solveKnapNaive(data)
    val2, sol2 = solveKnapModel(data, GLPK.Optimizer)
    val3, sol3 = solveKnapNaive(data)
    @test !isempty(sol1)
    @test !isempty(sol2)
    @test !isempty(sol3)
    @test val1 == val2 == val3
end
