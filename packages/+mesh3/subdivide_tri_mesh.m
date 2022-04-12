function [vertices, new_faces] = subdivide_tri_mesh(vertices, faces, n)
% SUBDIVIDE_TRI_MESH subdivides a triangle mesh
%
% Author: Paulo A. Pagliosa
% Last revision: 21/06/2012
%
% Input
% =====
% VERTICES: nv x 3 matrix of coordinates of the nv vertices of the mesh.
% FACES: nf x 3 matrix of connectivity of the nf faces of the mesh.
% N: number of subdivisions.
%
% Output
% ======
% VERTICES: nnv x 3 matrix of coordinates of the nnv new vertices.
% NEW_FACES: nnf x 3 matrix of connectivity of the nnf new faces.
%
% Description
% ===========
% [VERTICES, NEW_FACES] = SUBDIVIDE_TRI_MESH(VERTICES, FACES, N)
% subdivides each one of the faces FACES in N ^ 2 new faces which are
% added into NEW_FACES. New vertices resulting from subdivision are
% added into VERTICES.

  if n <= 0
    new_faces = faces;
    return;
  end
  nnv = size(vertices, 1);
  ev_table = cell(nnv);
  nof = size(faces, 1);
  new_faces = zeros(nof * n ^ 2, 3);
  nnf = 0;
  for f = 1 : nof
    face_faces = subdivide_face(f, n);
    nff = size(face_faces, 1);
    new_faces(nnf + 1 : nnf + nff, :) = face_faces;
    nnf = nnf + nff;
  end
 
  function new_faces = subdivide_face(f, n)
    v1 = faces(f, 1);
    v2 = faces(f, 2);
    v3 = faces(f, 3);
    e1 = split_edge(v1, v2, n);
    e2 = split_edge(v1, v3, n);
    e3 = split_edge(v2, v3, n);
    nf = 0;
    for j = 2 : n
      s1 = e2(j);
      s2 = e3(j);
      ns = n - j + 1;
      e4 = subdivide_edge(s1, s2, ns);
      vj = v1;
      sj = s1;
      for i = 2 : ns + 1
        si = e4(i);
        vi = e1(i);
        add_face(vj, vi, sj);
        add_face(sj, vi, si);
        sj = si;
        vj = vi;
      end
      add_face(vj, v2, sj);
      e1 = e4;
      v1 = s1;
      v2 = s2;
    end
    add_face(v1, v2, v3);

    function add_face(v1, v2, v3)
      nf = nf + 1;
      new_faces(nf, :) = [v1 v2 v3];
    end
  end

  function ev = split_edge(v1, v2, n)
    ev = ev_table{v1, v2};
    if isempty(ev)
      ev = subdivide_edge(v1, v2, n);
      ev_table{v1, v2} = ev;
      ev_table{v2, v1} = fliplr(ev);
    end
  end

  function ev = subdivide_edge(v1, v2, n)
    ev = zeros(1, n + 1);
    ev(1) = v1;
    ev(n + 1) = v2;
    if n > 1
      p1 = vertices(v1, :);
      p2 = vertices(v2, :);
      dp = (p2 - p1) / n;
      for i = 2 : n
        nnv = nnv + 1;
        ev(i) = nnv;
        p1 = p1 + dp;
        vertices(nnv, :) = p1;
      end
    end
  end
end
