function allstars = create_allstars(vertices, faces)
  %Recebe os vertices e faces e devolve um vetor que para cada linha tem a
  %estrela do vertice (está orientada)

  indices = [1:size(faces,1)];
  faces = [faces indices'];
  number_of_vertices = size(vertices,1);

  for vertex = 1:number_of_vertices
    f1 = faces(faces(:,1)==vertex,:);
    f2 = faces(faces(:,2)==vertex,[2 3 1 4]);
    f3 = faces(faces(:,3)==vertex,[3 1 2 4]);
    f = [f1;f2;f3];
    assert(size(f,1) > 2);
    star = f(1,:);
    for i = 1:size(f,1)-1
      next_cell = f(f(:,2)==star(i,3),:);
      if size(next_cell,1) ~= 1 % buraco!  %troquei != por ~=
        return
      end
      star = [ star; next_cell];
    end
    allstars(vertex).star = star;
  end

end