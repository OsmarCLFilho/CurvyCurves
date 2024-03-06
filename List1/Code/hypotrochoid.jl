using Symbolics
using Plots

include("utils.jl")

@variables θ R r d

C = (x=(R - r)*cos(θ), y=(R - r)*sin(θ));
ϕ = (R/r - 1)*θ;
P = (x=C.x + d*cos(ϕ), y=C.y - d*sin(ϕ));
#=
(x, y) = substitute.((P.x, P.y), (Dict(
    R => 4,
    r => 1,
    d => 1
),))

points = curvepoints(x, y, θ, range(0, 2π, length=100));
vectors = tangvectors(x, y, θ, range(0, 2π, length=100));

(plt, anim) = genvis(points, vectors; xlim=(-5,5), ylim=(-5,5));

savefig(plt, "astroid.png");
gif(anim, "astroid.gif");

(plt, anim) = genvis(vectors; xlim=(-7,7), ylim=(-7,7));

gif(anim, "astvecs.gif"; fps=60);
=#
(x, y) = substitute.((P.x, P.y), (Dict(
    R => 5,
    r => 7,
    d => 2.2 
),));

points = curvepoints(x, y, θ, range(0, 15π, length=300));
vectors = tangvectors(x, y, θ, range(0, 15π, length=300));

(plt, anim) = genvis(points, vectors; xlim=(-5,5), ylim=(-5,5));

savefig(plt, "hypotch.png");
