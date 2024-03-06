using Symbolics
using Plots

include("utils.jl")

@variables t

x1 = t
y1 = t^2

x2 = t^3
y2 = t^6

#=
points1 = curvepoints(x1, y1, t, range(-5, 5, length=100))
points2 = curvepoints(x2, y2, t, range(-2, 2, length=100))

vectors1 = tangvectors(x1, y1, t, range(-5, 5, length=100))
vectors2 = tangvectors(x2, y2, t, range(-2, 2, length=100))

(plt1, anim1) = genvis(points1, vectors1)
(plt2, anim2) = genvis(points2, vectors2)

savefig(plt1, "parabol1.png")
savefig(plt2, "parabol2.png")
gif(anim1, "parabol1.gif")
gif(anim2, "parabol2.gif")
=#

Dt = Differential(t);
(dx1, dy1, dx2, dy2) = expand_derivatives.(Dt.((x1, y1, x2, y2)));

dpts1 = curvepoints(dx1, dy1, t, range(-5, 5, length=100))
dpts2 = curvepoints(dx2, dy2, t, range(-2, 2, length=100))

(pltd1, _) = genvis(dpts1; xlim=(-2,4))
(pltd2, _) = genvis(dpts2; xlim=(-2,8))

savefig(pltd1, "derparab1.png")
savefig(pltd2, "derparab2.png")
