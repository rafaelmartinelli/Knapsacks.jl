function solveKnapsackModel(data::KnapsackData, optimizer)
    I = collect(1:length(data.weights))
    W = data.capacity
    w = data.weights
    p = data.profits

    model = Model(optimizer)

    @variable(model, x[j in I], Bin)
    @objective(model, Max, sum(p[j] * x[j] for j in I))
    @constraint(model, sum(w[j] * x[j] for j in I) <= W)

    optimize!(model)
    if termination_status(model) == MOI.OPTIMAL
        result = [ j for j in I if value(x[j]) > EPS ]
        return result
    end
end
