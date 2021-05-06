using KnapsackLib
using Test
using GLPK

@testset "Data" begin
    data = KnapsackData(10, [ 2, 3, 4, 5, 6 ], [ 2, 4, 6, 8, 10 ])
    @test_nowarn println(data)
    @test data.capacity == 10
    @test length(data.weights) == 5
    @test data.profits[3] == 6
end

@testset "Model" begin
    data = KnapsackData(10, [ 2, 3, 4, 5, 6 ], [ 2, 4, 5, 6, 10 ])
    solution = solveKnapsackModel(data, GLPK.Optimizer)
    @test solution == [ 3, 5 ]
    @test sum(data.profits[j] for j in solution) == 15
end

@testset "DinProg" begin
    data = KnapsackData(10, [ 2, 3, 4, 5, 6 ], [ 2, 4, 5, 6, 10 ])
    solution = solveKnapsackDinProg(data)
    @test solution == [ 3, 5 ]
    @test sum(data.profits[j] for j in solution) == 15
end

@testset "Random" begin
    n = 100
    weights = rand(1:10, n)
    profits = rand(1:10, n)
    capacity = sum(weights) ÷ 2
    data = KnapsackData(capacity, weights, profits)
    solution1 = solveKnapsackDinProg(data)
    solution2 = solveKnapsackModel(data, GLPK.Optimizer)
    @test !isempty(solution1)
    @test !isempty(solution2)
    @test sum(data.profits[j] for j in solution1) == sum(data.profits[j] for j in solution2)
end
