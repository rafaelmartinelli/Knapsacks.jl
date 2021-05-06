using KnapsackLib
using LinearAlgebra

mutable struct Item
    weight::Int64
    profit::Number
    solution::Bool
end

struct Interval
    first::Int64
    last::Int64
    weight::Int64
end

mutable struct GlobalData
    items::Vector{Item}
    capacity::Int64

    br::Int64
    wsb::Int64
    psb::Int64
    z::Int64
    fsort::Int64
    lsort::Int64

    stack1::Vector{Interval}
    stack2::Vector{Interval}

    estack::Vector{Int64}

    dantzig::Int64

    GlobalData() = new([], 0, 0, 0, 0, 0, 0, 0, [], [], [], 0)
end

function partsort(gd::GlobalData, f::Int64, l::Int64, ws::Int64)
    d = l - f + 1
    if d > 1
        m = f + d ÷ 2
        
        if det([ gd.items[f].profit gd.items[f].weight; gd.items[m].profit gd.items[m].weight ]) < 0
            gd.items[f], gd.items[m] = gd.items[m], gd.items[f]
        end

        if d > 2
            if det([ gd.items[m].profit gd.items[m].weight; gd.items[l].profit gd.items[l].weight ]) < 0
                gd.items[m], gd.items[l] = gd.items[l], gd.items[m]

                if det([ gd.items[f].profit gd.items[f].weight; gd.items[m].profit gd.items[m].weight ]) < 0
                    gd.items[f], gd.items[m] = gd.items[m], gd.items[f]
                end
            end
        end
    end

    if d <= 3
        return Interval(f, l, ws)
    else
        mp = gd.items[m].profit
        mw = gd.items[m].weight
        i = f
        j = l
        wi = ws
        while true
            while true
                wi += gd.items[i].weight
                i += 1
                if det([ gd.items[i].profit gd.items[i].weight; mp mw ]) <= 0 break end
            end
            while true
                j -= 1
                if det([ gd.items[j].profit gd.items[j].weight; mp mw ]) >= 0 break end
            end
            if i > j break end
            gd.items[i], gd.items[j] = gd.items[j], gd.items[i]
        end

        if wi > gd.capacity
            push!(gd.stack2, Interval(i, l, wi))
            return partsort(gd, f, i - 1, ws)
        else
            push!(gd.stack1, Interval(f, i - 1, ws))
            return partsort(gd, i, l, wi)
        end
    end
end

function heuristic(gd::GlobalData, f::Int64, l::Int64)
    ps = 0
    ws = gd.capacity

    i = f
    while gd.items[i].weight < ws
        ws -= gd.items[i].weight
        ps += gd.items[i].profit
        gd.items[i].solution = true
        i += 1
    end

    gd.br = i
    gd.wsb = gd.capacity - ws
    gd.psb = ps

    #TODO: Check if we need integral division!
    dz = (gd.capacity - gd.wsb) * gd.items[gd.br].profit ÷ gd.items[gd.br].weight
    gd.dantzig = gd.psb + dz

    empty!(gd.estack)
    gd.z = 0
    if gd.z == dz return gd.z end

    r = gd.capacity - gd.wsb
    for i in gd.br:l
        if (gd.items[i].weight <= r) && (gd.items[i].profit > gd.z)
            empty!(gd.estack)
            push!(gd.estack, i)
            gd.z = gd.items[i].profit
            if gd.z == dz return gd.z end
        end
    end

    r = gd.wsb + gd.items[gd.br].weight - gd.capacity
    pb = gd.items[gd.br].profit
    for i in gd.br - 1:-1:f
        if (gd.items[i].weight >= r) && (pb - gd.items[i].profit > gd.z)
            empty!(gd.estack)
            push!(gd.estack, gd.br)
            push!(gd.estack, i)
            gd.z = pb - gd.items[i].profit
            if gd.z == dz return gd.z end
        end
    end

    return gd.z
end

function reduce(gd::GlobalData, interval::Interval)

end

function sorti(gd::GlobalData, stack::Vector{Item})
    if isempty(stack) return false end

    interval = pop!(stack)
    reduce(interval)
    interval = partsort(gd, interval.first, interval.last, interval.weight)
    if interval.first < gd.fsort gd.fsort = interval.first end
    if interval.last < gd.lsort gd.lsort = interval.last end

    return true
end

function elebranch(gd::GlobalData, ps::Int64, ws::Int64, s::Int64, t::Int64)
    improved = false

    if ws <= 0
        if ps > z
            improved = true
            gd.z = ps
            empty!(gd.estack)
        end

        while true
            if t > gd.lsort && !sorti(gd.stack2) break end
            if det([ ps - (gd.z + 1) ws; gd.items[t].profit gd.items[t].weight ]) < 0 break end
            if elebranch(ps + gd.items[t].profit, ws + gd.items[t].weight, s, t + 1)
                improved = true
                push!(gd.estack, t)
            end
            t += 1
        end
    else
        while true
            if s < gd.fsort && !sorti(gd.stack1) break end
            if det([ ps - (gd.z + 1) ws; gd.items[s].profit gd.items[s].weight ]) < 0 break end
            if elebranch(ps - gd.items[s].profit, ws - gd.items[s].weight, s - 1, t)
                improved = true
                push!(gd.estack, s)
            end
            s -= 1
        end
    end

    return improved
end

function definesolution(gd::GlobalData)

end

function expknap(data::KnapsackData)
    n = length(data.weights)

    gd = GlobalData()
    gd.items = [ Item(data.weights[i], data.profits[i], false) for i in 1:n ]
    gd.capacity = data.capacity

    interval = partsort(gd, 1, n, 0)
    gd.fsort = interval.first
    gd.lsort = interval.last

    gd.z = heuristic(gd, 1, n)
    heur = gd.z + gd.psb
    elebranch(gd, 0, gd.wsb - gd.capacity, gd.br - 1, gd.br)

    definesolution(gd)

    gd.items, interval, gd.z + gd.psb
end

data = KnapsackData(10, [ 2, 3, 4, 5, 6 ], [ 2, 4, 5, 6, 10 ])
@time items = expknap(data)
