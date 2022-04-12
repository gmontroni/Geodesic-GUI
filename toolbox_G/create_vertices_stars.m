function fullmesh = create_vertices_stars( fullmesh )
%Recebe os vertices e faces e devolve um vetor que para cada linha tem a
%estrela do vertice (está orientada)

indices = 1:size(fullmesh.triangles,1);
faces = [fullmesh.triangles indices'];
for vertex = 1:fullmesh.number_of_vertices
    f1 = faces(faces(:,1)==vertex,:);
    f2 = faces(faces(:,2)==vertex,[2 3 1 4]);
    f3 = faces(faces(:,3)==vertex,[3 1 2 4]);
    f = [f1;f2;f3];
    assert(size(f,1) > 2, 'Is your mesh really a manifold? A vertex has less than two triangles.' );
    star = zeros(size(f,1),4);
    star(1,:) = f(1,:);
    for i = 2:size(f,1)
        next_cell = f(f(:,2)==star(i-1,3),:);
        assert(size(next_cell,1) == 1, 'Is your mesh really a manifold? A boundary has been found.');
        star(i,:) = next_cell;
    end
    fullmesh.vertices(vertex).star = star;
end
end