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

@variables t a

x = (2*a*t^2)/(t^2 + 1);
y = (2*a*t^3)/(t^2 + 1);

x = substitute(x, Dict(a => 1));
y = substitute(y, Dict(a => 1));

points = curvepoints(x, y, t, range(-5, 5, 100));

# Generate still image
#plt = plot((points[:,1], points[:,2]); linewidth=2, size=(500, 500), xlim=(-5, 7), ylim=(-6, 6));

plt = plot(1; linewidth=2, size=(500, 500), xlim=(-5, 7), ylim=(-6,6));
anim = @animate for i = 1:100
    push!(plt, points[i, 1], points[i, 2])
end

gif(anim, "diocis.gif"; fps=24);
