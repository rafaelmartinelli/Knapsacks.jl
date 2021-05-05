using KnapsackLib
using Test
using GLPK

@testset "KnapsackData" begin
    data = KnapsackData(10, [ 2, 3, 4, 5, 6 ], [ 2, 4, 6, 8, 10 ])
    @test_nowarn println(data)
    @test data.capacity == 10
    @test length(data.weights) == 5
    @test data.profits[3] == 6
end

@testset "KnapsackModel" begin
    data = KnapsackData(10, [ 2, 3, 4, 5, 6 ], [ 2, 4, 5, 6, 10 ])
    solution = solveKnapsackModel(data, GLPK.Optimizer)
    @test solution == [ 3, 5 ]
    @test sum(data.profits[j] for j in solution) == 15
end

@testset "KnapsackDinProg" begin
    data = KnapsackData(10, [ 2, 3, 4, 5, 6 ], [ 2, 4, 5, 6, 10 ])
    solution = solveKnapsackDinProg(data)
    @test solution == [ 3, 5 ]
    @test sum(data.profits[j] for j in solution) == 15
end
