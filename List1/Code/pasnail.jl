using Symbolics
using Plots

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

@variables t

x = (1 + 2cos(t))*cos(t);
y = (1 + 2cos(t))*sin(t);

points = curvepoints(x, y, t, range(0, 2π, length = 120));

#plt = plot((points[:,1], points[:,2]); size=(500, 500), linewidth=2)

plt = plot(1; size=(500, 500), linewidth=2, xlim=(-2,3.2), ylim=(-2.6,2.6));
anim = @animate for i = 1:120
    push!(plt, (points[i,1], points[i,2]))
end

# gif(anim, "pasnail.gif");

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

vectors = tangvectors(x, y, t, [2π/3 4π/3]);
plot!(plt, (vectors[:,1], vectors[:,2]); linecolor=:red, arrow=true)
