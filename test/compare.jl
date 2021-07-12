using KnapsackLib
using GLPK
using Printf

# runs = 10000
# sizes = [ 5 ]
# max_vals = [ 10 ]
runs = 10
sizes = [ 10, 100, 500, 1000, 2000, 4000 ]
max_vals = [ 10, 100, 500, 1000, 2000 ]

times = []

for v in max_vals
    sizes_times = []
    for n in sizes
        algos_times = zeros(Float64, 4)
        for r = 1:runs
            data = genKnap(n, v; seed = r)

            ret1 = @timed solveKnapNaive(data)
            ret2 = @timed solveKnapModel(data, GLPK.Optimizer)
            ret3 = @timed solveKnapExpCore(data)
            ret4 = @timed solveKnapHeur(data)

            val1, sol1 = ret1.value
            val2, sol2 = ret2.value
            val3, sol3 = ret3.value

            algos_times[1] += ret1.time / runs
            algos_times[2] += ret2.time / runs
            algos_times[3] += ret3.time / runs
            algos_times[4] += ret4.time / runs

            w1 = sum(data.items[j].weight for j in sol1)
            w2 = sum(data.items[j].weight for j in sol2)
            w3 = sum(data.items[j].weight for j in sol3)

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

@printf "%10s " ""
for n in 1:length(sizes)
    @printf "%10d " sizes[n]
end
@printf "\n"

for v in 1:length(max_vals)
    for i in 1:4
        if i == 2
            @printf "%10d " max_vals[v]
        else
            @printf "%10s " ""
        end

        for n in 1:length(sizes)
            @printf "%10.7lf " times[v][n][i]
        end
        @printf "\n"
    end
end
