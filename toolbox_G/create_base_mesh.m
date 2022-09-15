function fullmesh = create_base_mesh( fullmesh )
quads = [];
tris = [];
%edges = [0 0];
for geo = 1:fullmesh.number_of_geodesics
    vertex1 = fullmesh.paths_ends(geo,1);
    vertex2 = fullmesh.paths_ends(geo,2);
    [ quad1, tri1, ~ ] = define_quad_or_tri(vertex1, geo, fullmesh);
    [ quad2, tri2, ~ ] = define_quad_or_tri(vertex2, geo, fullmesh);
    quads = [quads; quad1; quad2];
    tris = [tris; tri1; tri2];
end

qvertices_id = unique(fullmesh.paths_ends);              %retira os vertices repetidos
fullmesh.base_mesh.coords = fullmesh.coords(qvertices_id,:);
fullmesh.base_mesh.number_of_vertices = size(qvertices_id,1);
fullmesh.base_mesh.base_vertices_to_dense_vertices = qvertices_id;
vertices_to_qvertices = full(sparse( qvertices_id, 1, [1:fullmesh.base_mesh.number_of_vertices]'));
fullmesh.base_mesh.dense_vertices_to_base_vertices = vertices_to_qvertices;
if size(fullmesh.base_mesh.dense_vertices_to_base_vertices,1) < fullmesh.number_of_vertices
    fullmesh.base_mesh.dense_vertices_to_base_vertices(fullmesh.number_of_vertices) = 0;
end

q = 1;
while q < size(quads,1)   %retira os quadriláteros repetidos
    repetidos = all(  quads == [quads(q,2) quads(q,3) quads(q,4) quads(q,1)] | ...
        quads == [quads(q,3) quads(q,4) quads(q,1) quads(q,2)] | ...
        quads == [quads(q,4) quads(q,1) quads(q,2) quads(q,3)],2);
    assert(sum(repetidos) == 3, 'base mesh error');
    quads(repetidos,:) = [];
    q = q + 1;
end

t = 1;
while t < size(tris,1)  %retira os triangulos repetidos
    repetidos = all(  tris == [tris(t,2) tris(t,3) tris(t,1)] | ...
        tris == [tris(t,3) tris(t,1) tris(t,2)],2);
    assert(sum(repetidos) == 2, 'base mesh error');
    tris(repetidos,:) = [];
    t = t + 1;
end

fullmesh.base_mesh.quads = zeros(size(quads,1), 4);
for q = 1:size(quads,1)
    fullmesh.base_mesh.quads(q,:) = [ vertices_to_qvertices(quads(q,1)) vertices_to_qvertices(quads(q,2)) vertices_to_qvertices(quads(q,3)) vertices_to_qvertices(quads(q,4)) ];
end
fullmesh.base_mesh.triangles = zeros(size(tris,1), 3);
for t = 1:size(tris,1)
    fullmesh.base_mesh.triangles(t,:) = [ vertices_to_qvertices(tris(t,1)) vertices_to_qvertices(tris(t,2)) vertices_to_qvertices(tris(t,3)) ];
end

fullmesh.base_mesh.number_of_quads = size(quads,1);
fullmesh.base_mesh.number_of_triangles = size(tris,1);
end