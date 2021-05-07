function solveKnapModel(data::KnapData, optimizer)
    I = collect(1:length(data.items))
    W = data.capacity
    w = [ item.weight for item in data.items ]
    p = [ item.profit for item in data.items ]

    model = Model(optimizer)

    @variable(model, x[j in I], Bin)
    @objective(model, Max, sum(p[j] * x[j] for j in I))
    @constraint(model, sum(w[j] * x[j] for j in I) <= W)

    optimize!(model)
    if termination_status(model) == MOI.OPTIMAL
        result = [ j for j in I if value(x[j]) > EPS ]
        return round(Int64, objective_value(model)), result
    end
end
