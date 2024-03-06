function curvepoints(xexp::Num, yexp::Num, param::Num, values)
    vlen = length(values)

    points = zeros((vlen, 2))

    for i = 1:vlen
        t = values[i]
        points[i, :] = Symbolics.value.(
            substitute.([xexp yexp], (Dict(param => t),))
        )
    end

    return points
end

function tangvectors(xexp::Num, yexp::Num, param::Num, values)
    vlen = length(values)*3

    vectors = zeros((vlen, 2))

    D = Differential(param)
    dxexp = expand_derivatives(D(xexp))
    dyexp = expand_derivatives(D(yexp))

    tanvec = [
        xexp yexp (xexp + dxexp) (yexp +dyexp)
    ]

    for i = 1:3:vlen
        t = values[(i÷3) + 1]
        vectors[i, :] = Symbolics.value.(
            substitute.([xexp yexp], (Dict(param => t),))
        )
        vectors[i+1, :] = Symbolics.value.(
            substitute.([xexp+dxexp yexp+dyexp], (Dict(param => t),))
        )
        vectors[i+2, :] = [NaN NaN]
    end

    return vectors
end

function genvis(points; xlim=:auto, ylim=:auto)
    plt = plot(1; linewidth=2, size=(500,500), xlim=xlim, ylim=ylim)
    anim = @animate for i = 1:size(points, 1)
        push!(plt, points[i,1], points[i,2])
    end

    return (plt, anim)
end

# Multiple dispatch of genvis. We can either pass only points, or both points and vectors.
# The compiler will figure out which version of the function to call.
function genvis(points, vectors; xlim=:auto, ylim=:auto)
    len = size(points, 1)
    anim = @animate for i = 1:len
        plt = plot(points[1:i,1], points[1:i,2]; linewidth=2, size=(500,500), xlim=xlim, ylim=ylim)
        plot!(plt, vectors[(3*i - 2):i*3, 1], vectors[(3*i - 2):i*3, 2]; linecolor=:red, arrow=true)
    end

    plt = plot(points[1:len,1], points[1:len,2]; linewidth=2, size=(500,500), xlim=xlim, ylim=ylim)

    return (plt, anim)
end
