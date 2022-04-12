function [qvertices, qfaces, tfaces ] = create_quad_tri_mesh(vertices, geodesics, geodesics_oriented)
  quads = [];
  tris = [];
  %edges = [0 0];
  number_of_geodesics = size(geodesics,1);  
  for geo = 1:number_of_geodesics    
    vertex1 = geodesics(geo,1);
    vertex2 = geodesics(geo,2);    
    %if ~any(edges( edges == [vertex1 vertex2] | edges == [vertex2 vertex1] ))
      [ quad1 tri1 edges1 ] = define_quad_or_tri(vertex1, geo, geodesics, geodesics_oriented);
      [ quad2 tri2 edges2 ] = define_quad_or_tri(vertex2, geo, geodesics, geodesics_oriented);
      quads = [quads; quad1; quad2];
      tris = [tris; tri1; tri2];
      %edges = [edges; [vertex1 vertex2]; [vertex2 vertex1]];
    %end
  end   
  
  qvertices_id = unique(geodesics);              %retira os vertices repetidos
  qvertices = vertices(qvertices_id,:);
  number_of_qvertices = size(qvertices_id,1);
  vertices_to_qvertices = full(sparse( qvertices_id, 1, [1:number_of_qvertices]')); 
  
  q = 1;
  while q < size(quads,1)   %retira os qudriláteros repetidos
      repetidos = all(  quads == [quads(q,2) quads(q,3) quads(q,4) quads(q,1)] | ...
                      quads == [quads(q,3) quads(q,4) quads(q,1) quads(q,2)] | ...
                      quads == [quads(q,4) quads(q,1) quads(q,2) quads(q,3)],2);
      assert(sum(repetidos) == 3);
      quads(repetidos,:) = [];
      q = q + 1;
  end

  t = 1;
  while t < size(tris,1)  %retira os triangulos repetidos
    repetidos = all(  tris == [tris(t,2) tris(t,3) tris(t,1)] | ...
                      tris == [tris(t,3) tris(t,1) tris(t,2)],2);
    assert(sum(repetidos) == 2);
    tris(repetidos,:) = [];    
    t = t + 1;
  end
  
  qfaces = [];
  for q = 1:size(quads,1)
    qfaces = [ qfaces; vertices_to_qvertices(quads(q,1)) vertices_to_qvertices(quads(q,2)) vertices_to_qvertices(quads(q,3)) vertices_to_qvertices(quads(q,4)) ];
  end
  tfaces = [];
  for t = 1:size(tris,1)
    tfaces = [ tfaces; vertices_to_qvertices(tris(t,1)) vertices_to_qvertices(tris(t,2)) vertices_to_qvertices(tris(t,3)) ];
  end
end