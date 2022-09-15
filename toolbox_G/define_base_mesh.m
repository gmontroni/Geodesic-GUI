function edgespaint = define_base_mesh( fullmesh )
% copia da original
quads = [];
tris = [];
edges = [];
for geo = 1:fullmesh.number_of_geodesics
    vertex1 = fullmesh.paths_ends(geo,1);           % vertice inicial da geodésica
    vertex2 = fullmesh.paths_ends(geo,2);           % vértice final da geodésica   
    [ quad1, tri1, edges1 ] = paint_quad_or_tri(vertex1, geo, fullmesh);
    [ quad2, tri2, edges2 ] = paint_quad_or_tri(vertex2, geo, fullmesh);
    quads = [quads; quad1; quad2];
    tris = [tris; tri1; tri2];
    edges = [edges; edges1; edges2];
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
    % assert(sum(repetidos) == 3, 'base mesh error');
    quads(repetidos,:) = [];
    q = q + 1;
end

t = 1;
while t < size(tris,1)  %retira os triangulos repetidos
    repetidos = all(  tris == [tris(t,2) tris(t,3) tris(t,1)] | ...
        tris == [tris(t,3) tris(t,1) tris(t,2)],2);
    % assert(sum(repetidos) == 2, 'base mesh error');
    tris(repetidos,:) = [];
    t = t + 1;
end


edges = unique(edges, 'rows');   %retira as arestas repetidas

p = 1;
edgespaint = [];
while p < size(edges,1)  %retira os triangulos repetidos
    repetidos = all(edges(p,:) == edges | edges(p,:) == flip(edges,2),2);
    if sum(repetidos) >= 2
        edgespaint = [edgespaint; edges(p,:)];
        p = 1;
    end
    edges(repetidos,:) = [];
    p = p + 1;
end

end