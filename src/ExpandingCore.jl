mutable struct Item
    index::Int64
    weight::Int64
    profit::Int64
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

    GlobalData() = new([], 0, 0, 0, 0, 0, 0, 0, [], [], [])
end

function solveKnapExpCore(data::KnapData)
    n = length(data.items)
    if n == 0 return 0, Int64[] end

    gd = GlobalData()
    gd.items = [ Item(i, data.items[i].weight, data.items[i].profit, false) for i in 1:n ]
    gd.capacity = data.capacity

    interval = partsort(gd, 1, n, 0)
    gd.fsort = interval.first
    gd.lsort = interval.last

    gd.z = heuristic(gd, 1, n)

    elebranch(gd, 0, gd.wsb - gd.capacity, gd.br - 1, gd.br)
    
    return gd.z + gd.psb, definesolution(gd)
end

function det(a::Matrix{Int64})
    return a[1, 1] * a[2, 2] - a[1, 2] * a[2, 1]
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
    while gd.items[i].weight <= ws
        ws -= gd.items[i].weight
        ps += gd.items[i].profit
        gd.items[i].solution = true
        i += 1
    end

    gd.br = i
    gd.wsb = gd.capacity - ws
    gd.psb = ps

    dz = (gd.capacity - gd.wsb) * gd.items[gd.br].profit ÷ gd.items[gd.br].weight

    empty!(gd.estack)
    gd.z = 0
    if gd.z == dz return gd.z end

    r = gd.capacity - gd.wsb
    for i in gd.br:l
        if (gd.items[i].weight <= r) && (gd.items[i].profit > gd.z)
            empty!(gd.estack)
            push!(gd.estack, gd.items[i].index)
            gd.z = gd.items[i].profit
            if gd.z == dz return gd.z end
        end
    end

    r = gd.wsb + gd.items[gd.br].weight - gd.capacity
    pb = gd.items[gd.br].profit
    for i in gd.br - 1:-1:f
        if (gd.items[i].weight >= r) && (pb - gd.items[i].profit > gd.z)
            empty!(gd.estack)
            push!(gd.estack, gd.items[gd.br].index)
            push!(gd.estack, gd.items[i].index)
            gd.z = pb - gd.items[i].profit
            if gd.z == dz return gd.z end
        end
    end

    return gd.z
end

function reduce(gd::GlobalData, first::Int64, last::Int64)
    pb = gd.items[gd.br].profit
    wb = gd.items[gd.br].weight

    q = det([ gd.z + 1 gd.capacity - gd.wsb; pb wb ])
    i = first
    j = last

    if i <= gd.br
        k = gd.fsort - 1
        while i <= j
            if det([ -gd.items[j].profit -gd.items[j].weight; pb wb ]) < q
                gd.items[i], gd.items[j] = gd.items[j], gd.items[i]
                i += 1
            else
                gd.items[j], gd.items[k] = gd.items[k], gd.items[j]
                j -= 1
                k -= 1
            end
        end
        if k == gd.fsort - 1
            gd.items[first], gd.items[k] = gd.items[k], gd.items[first]
            k -= 1
        end
        last = gd.fsort - 1
        first = k + 1
    else
        k = gd.lsort + 1
        while i <= j
            if det([ gd.items[i].profit gd.items[i].weight; pb wb ]) < q
                gd.items[i], gd.items[j] = gd.items[j], gd.items[i]
                j -= 1
            else
                gd.items[i], gd.items[k] = gd.items[k], gd.items[i]
                i += 1
                k += 1
            end
        end
        if k == gd.lsort + 1
            gd.items[last], gd.items[k] = gd.items[k], gd.items[last]
            k += 1
        end
        first = gd.lsort + 1
        last = k - 1
    end
    return first, last
end

function sorti(gd::GlobalData, stack::Vector{Interval})
    if isempty(stack) return false end

    interval = pop!(stack)
    first, last = reduce(gd, interval.first, interval.last)
    interval = partsort(gd, first, last, interval.weight)
    if interval.first < gd.fsort gd.fsort = interval.first end
    if interval.last > gd.lsort gd.lsort = interval.last end

    return true
end

function elebranch(gd::GlobalData, ps::Int64, ws::Int64, s::Int64, t::Int64)
    improved = false

    if ws <= 0
        if ps > gd.z
            improved = true
            gd.z = ps
            empty!(gd.estack)
        end

        while true
            if t > gd.lsort && !sorti(gd, gd.stack2) break end
            if det([ ps - (gd.z + 1) ws; gd.items[t].profit gd.items[t].weight ]) < 0 break end
            if elebranch(gd, ps + gd.items[t].profit, ws + gd.items[t].weight, s, t + 1)
                improved = true
                push!(gd.estack, gd.items[t].index)
            end
            t += 1
        end
    else
        while true
            if s < gd.fsort && !sorti(gd, gd.stack1) break end
            if det([ ps - (gd.z + 1) ws; gd.items[s].profit gd.items[s].weight ]) < 0 break end
            if elebranch(gd, ps - gd.items[s].profit, ws - gd.items[s].weight, s - 1, t)
                improved = true
                push!(gd.estack, gd.items[s].index)
            end
            s -= 1
        end
    end

    return improved
end

function definesolution(gd::GlobalData)
    sort!(gd.items, by = x -> x.index)
    for index in gd.estack
        gd.items[index].solution = !gd.items[index].solution
    end

    solution = Int64[]
    for item in gd.items
        if item.solution
            push!(solution, item.index)
        end
    end
    return solution
end
