using Plots
using Symbolics

include("utils.jl");

@variables t

γ = (x=ℯ^t * cos(t), y=ℯ^t * sin(t));

points = curvepoints(γ.x, γ.y, t, range(0, 8π, length=200));

function symgenvis(points)
    plt = plot(1; linewidth=2, size=(700,500), aspect_ratio=:equal, lims=:symmetric, yrotation=90)
    anim = @animate for i = 1:size(points, 1)
        push!(plt, points[i,1], points[i,2])
    end

    return (plt, anim)
end

(plt, anim) = symgenvis(points);

savefig(plt, "spirl.png");
gif(anim, "spirl.gif"; fps=24);
