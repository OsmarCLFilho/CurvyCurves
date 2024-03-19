using Reduce
@force using Reduce.Algebra

using Plots

#Item 1
#=
r = :r;
t = :t;

x = r*cos(t);
y = r*sin(t);

x1d = df(x, t);
y1d = df(y, t);

l = sqrt(x1d^2 + y1d^2);

L = int(l, t, 0, π)
=#

#Item 2
#=
t = :t;

x = t;
y = (t^2)/2;

x1d = df(x, t);
y1d = df(y, t);

l = sqrt(x1d^2 + y1d^2);

L = int(l, t, 0, 1)
=#

#Item 3

r = :r;
t = :t;
s = :s;

αfunc(targ, rarg) = (rarg*cos(targ), rarg*sin(targ));
ϕ = s/r;

α = αfunc(t, r);
β = αfunc(ϕ, r);

α1t = df.(α, t);
β1s = df.(β, s);

α2t = df.(α1t, t);
β2s = df.(β1s, s);

trange = range(0, 4π, length=100);
srange = range(0, 4π, length=100);

xvalues = zeros(Float64, 100);
yvalues = zeros(Float64, 100);

for i=1:100
    (xvalues[i], yvalues[i]) = eval.(sub.(
        (Dict(
            t => trange[i],
            r => 2
        ),), α
    ));
end

base_plt = plot((xvalues, yvalues);
    linewidth=2,
    label="",
    size=(600,600),
    lim=(-3,3)
);

vecα = [
    α[1]            α[2]
    (α[1] + α1t[1]) (α[2] + α1t[2])
    NaN             NaN
    α[1]            α[2]
    (α[1] + α2t[1]) (α[2] + α2t[2])
];

vecβ = [
    β[1]            β[2]
    (β[1] + β1s[1]) (β[2] + β1s[2])
    NaN             NaN
    β[1]            β[2]
    (β[1] + β2s[1]) (β[2] + β2s[2])
];

anim = @animate for i=1:100
    plt = plot(base_plt);

    numvecα = eval.(sub.(
        (Dict(
            t => trange[i],
            r => 2
        ),), (vecα[:,1], vecα[:,2])
    ))

    numvecβ = eval.(sub.(
        (Dict(
            s => srange[i],
            r => 2
        ),), (vecβ[:,1], vecβ[:,2])
    ))

    plot!(plt, [numvecα, numvecβ];
        arrow=true,
        linewdith=2,
        label=""
    );
end

gif(anim, "circpara.gif");
