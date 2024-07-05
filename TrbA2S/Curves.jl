using Plots, Symbolics

function trigvertx_rect(width, height, sidelength)
    xlen = floor(Int64, (width÷sidelength) - 0.5) + 1
    ylen = floor(Int64, height÷(sidelength*sqrt(3)/2)) + 1

    vertices = Array{Float64}(undef, (xlen, ylen, 2))
    for x=0:xlen-1, y=0:ylen-1
        vertices[x+1, y+1, 1] = (x + ((y%2)/2))*sidelength
        vertices[x+1, y+1, 2] = (y*(sqrt(3)/2))*sidelength
    end

    return vertices
end

function apply_trigvertx(vertices, f)
    (xlen, ylen, _) = size(vertices)

    newvertices = Array{Float64}(undef, (xlen, ylen, 3))
    for x=1:xlen, y=1:ylen
        (k, j, l) = f(vertices[x, y, 1], vertices[x, y, 2])
        newvertices[x, y, :] = [k, j, l]
    end

    return newvertices
end

function select_corevertices(vertices)
    (xlen, ylen, _) = size(vertices)
    
    x1v = collect(range(1,xlen; step=3))
    y1v = collect(range(1,ylen; step=2))
    x2v = collect(range(2,xlen; step=3))
    y2v = collect(range(2,ylen; step=2))

    len1 = length(x1v)*length(y1v)
    len2 = length(x2v)*length(y2v)
    vtx_indx1 = Array{Int64}(undef, (len1, 2))
    vtx_indx2 = Array{Int64}(undef, (len2, 2))

    for row=1:len1
        ly = length(y1v)
        vtx_indx1[row, 1] = x1v[1 + (row-1)÷ly]
        vtx_indx1[row, 2] = y1v[1 + (row-1)%ly]
    end

    for row=1:len2
        ly = length(y2v)
        vtx_indx2[row, 1] = x2v[1 + (row-1)÷ly]
        vtx_indx2[row, 2] = y2v[1 + (row-1)%ly]
    end

    return [vtx_indx1; vtx_indx2]
end

function trigmesh_rect(vertices)
    (xlen, ylen, _) = size(vertices)
    corevertices = select_corevertices(vertices)

    connections = Array{Int64}(undef, (2*(xlen-1)*(ylen-1), 3))
    trigcount = 1

    for row=1:size(corevertices, 1)
        x = corevertices[row, 1]
        y = corevertices[row, 2]

        m = (y+1)%2
        neighbors = [
            x+1   y
            x+m   y+1
            x-1+m y+1
            x-1   y
            x-1+m y-1
            x+m   y-1
        ]
        nsize = size(neighbors, 1)
        isbounded = (neighbors .>= [1 1]) .& (neighbors .<= [xlen ylen])
        isbounded = isbounded[:,1] .& isbounded[:,2]

        for n=1:nsize
            ngh1bound = isbounded[n] == 1
            ngh2indx = n != nsize ? n+1 : 1
            ngh2bound = isbounded[ngh2indx] == 1

            if ngh1bound && ngh2bound
                flatten = (a, b) -> 1 + (a-1)%xlen + (b-1)*xlen

                connections[trigcount, :] = [
                    flatten(x, y),
                    flatten(neighbors[n, 1], neighbors[n,2]),
                    flatten(neighbors[ngh2indx, 1], neighbors[ngh2indx, 2])
                ]

                trigcount += 1
            end
        end
    end

    return connections
end
