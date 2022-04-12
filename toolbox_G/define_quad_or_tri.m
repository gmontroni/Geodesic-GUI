function [ quad_ tri_ edges ] = define_quad_or_tri(vertex, geo, fullmesh )
quad_or_tri = zeros(4,1);
edges = zeros(4,2);
atual_vertex = vertex;
next_vertex = -1;
i = 0;
while next_vertex ~= vertex
    i = i + 1;
    assert(i < 5, 'only triangles or quads are allowed');  %tem que ser menor que 5
    next_geo = circshift(fullmesh.vertices(atual_vertex).paths_oriented==geo, -1);
    next_geo = fullmesh.vertices(atual_vertex).paths_oriented(next_geo);
    assert(size(next_geo,1)==1);
    if fullmesh.paths_ends(next_geo,1) == atual_vertex
        next_vertex = fullmesh.paths_ends(next_geo,2);
    else
        assert(fullmesh.paths_ends(next_geo,2) == atual_vertex);
        next_vertex = fullmesh.paths_ends(next_geo,1);
    end
    edges(i,:) = [ atual_vertex next_vertex ];
    quad_or_tri(i) = next_vertex;
    atual_vertex = next_vertex;
    geo = next_geo;
end
if i == 3
    tri_ = quad_or_tri(1:3,1)';
    quad_ = [];
else
    assert(i == 4, 'only triangles or quads are allowed');
    tri_ = [];
    quad_ = quad_or_tri';
end
end