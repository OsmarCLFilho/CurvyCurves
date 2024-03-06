using Plots
using Symbolics

include("utils.jl")

@variables t a b

(x, y) = (a*cos(t), b*sin(t));
(x, y) = substitute.((x, y), (Dict(
    a => 2,
    b => 3
),));

points = curvepoints(x, y, t, range(0, 2π, length=100));

(plt, anim) = genvis(points; xlim=(-4,4), ylim=(-4,4));

savefig(plt, "elips.png");
