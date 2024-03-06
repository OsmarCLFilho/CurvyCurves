using Symbolics
using Plots

@variables θ;

x = cos(θ);
y = sin(θ);

tlen = 100;
tvec = range(start=0, stop=2π, length=tlen);

# Initialize a plot with a single, empty series which
# the push! function inside the loop will target.
#=
plt = plot(1; size = (600, 600), lim = (-2, 2), linewidth = 2);
anim1 = @animate for t in tvec
    xval = Symbolics.value(substitute(x, Dict(θ => t)));
    yval = Symbolics.value(substitute(y, Dict(θ => t)));

    push!(plt, (xval, yval));
end
=#
#savefig(plt, "circle.png");
#gif(anim1, "circle.gif");


Dθ = Differential(θ);

# NaN entries are added to signal an interruption in the series, creating separated lines.
xDθ = expand_derivatives(Dθ(x));
yDθ = expand_derivatives(Dθ(y));

tanvec = [
    x        y
    x + xDθ  y + yDθ
];

v1 = Symbolics.value.(substitute.(tanvec, (Dict(θ => π/6),)));
v2 = Symbolics.value.(substitute.(tanvec, (Dict(θ => 2π/3),)));
v3 = Symbolics.value.(substitute.(tanvec, (Dict(θ => π),)));

v = [
    v1
    [NaN NaN]
    v2
    [NaN NaN]
    v3
];

# plot!(plt, (v[:,1], v[:,2]); linecolor=:red, arrow=true)

xvec = zeros(tlen);
yvec = zeros(tlen);

for i in 1:tlen
    t = tvec[i];
    xvec[i] = Symbolics.value(substitute(x, Dict(θ => t)));
    yvec[i] = Symbolics.value(substitute(y, Dict(θ => t)));
end

anim3 = @animate for i in 1:tlen
    t = tvec[i];
    v = Symbolics.value.(substitute.(tanvec, (Dict(θ => t),)));

    plot((xvec[1:i], yvec[1:i]); linewidth=2, size=(600,600), lim=(-2,2), label=nothing);
    plot!((v[:,1], v[:,2]); linecolor=:red, arrow=true, label=nothing);
end

gif(anim3, "circlevecs.gif");
