using Knapsacks
using GLPK
using Printf

# runs = 10000
# sizes = [ 5 ]
# max_vals = [ 10 ]
runs = 10
sizes = [ 10, 100, 500, 1000, 2000, 4000 ]
max_vals = [ 10, 100, 500, 1000, 2000 ]

function compareAlgorithms()
    times = []

    for v in max_vals
        sizes_times = []
        for n in sizes
            algos_times = zeros(Float64, 4)
            for r = 1:runs
                data = generateKnapsack(n, v; seed = r)

                ret1 = @timed solveKnapsack(data, :DynamicProgramming)
                ret2 = @timed solveKnapsack(data, :BinaryModel; optimizer = GLPK.Optimizer)
                ret3 = @timed solveKnapsack(data, :ExpandingCore)
                ret4 = @timed solveKnapsack(data, :Heuristic)

                val1, sol1 = ret1.value
                val2, sol2 = ret2.value
                val3, sol3 = ret3.value

                algos_times[1] += ret1.time / runs
                algos_times[2] += ret2.time / runs
                algos_times[3] += ret3.time / runs
                algos_times[4] += ret4.time / runs

                w1 = sum(data.weights[j] for j in sol1)
                w2 = sum(data.weights[j] for j in sol2)
                w3 = sum(data.weights[j] for j in sol3)

                if val1 != val2 || val2 != val3
                    println(val1, " (", w1, ") x ", val2, " (", w2, ") x ", val3, " (", w3, ")")

                    println(items)
                    println(capacity)

                    println(sol1)
                    println(sol2)
                    println(sol3)

                    @assert 1 != 1
                end
            end
            push!(sizes_times, algos_times)
        end
        push!(times, sizes_times)
    end
    return times
end

function printResults(times)
    algorithms = [ :DynamicProgramming, :BinaryModel, :ExpandingCore, :Heuristic ]
    bar = repeat("-", 98)

    @printf "%s\n" bar
    @printf " %10s " "MaxV\\Items"
    for n in 1:length(sizes)
        @printf "%10d " sizes[n]
    end
    @printf " Algorithm\n"
    @printf "%s\n" bar

    for v in 1:length(max_vals)
        for i in 1:4
            if i == 2
                @printf " %10d " max_vals[v]
            else
                @printf " %10s " ""
            end

            for n in 1:length(sizes)
                @printf "%10.7lf " times[v][n][i]
            end
            @printf " %s\n" algorithms[i]
        end
        @printf "%s\n" bar
    end
end

times = compareAlgorithms()
printResults(times)
