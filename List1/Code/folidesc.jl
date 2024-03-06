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

@variables θ

r = (3cos(θ)sin(θ))/(cos(θ)^3 + sin(θ)^3);

x = cos(θ)*r;
y = sin(θ)*r;

points = curvepoints(x, y, θ, range(-π/4 + 0.1, 3π/4 - 0.1, length=100));
vectors = tangvectors(x, y, θ, range(-π/4 + 0.1, 3π/4 - 0.1, length=100));
(plt, anim) = genvis(points, vectors; xlim=(-7,7), ylim=(-7,7));

gif(anim, "folidesc.gif"; fps=24)
plot(plt)
savefig(plt, "folidesc.png")

folidesc(x, y) = x^3 + y^3 - 3*x*y;
xvalues = range(-5, 5, length=150);
yvalues = range(-5, 5, length=150);
z = folidesc.(transpose(xvalues), yvalues);

levels = [
    range(-50, -5, step=5);
    range(-5, 5, step=0.5);
    range(5, 50, step=5);
];

con = contour(xvalues, yvalues, z; size=(500,500), levels=levels)
