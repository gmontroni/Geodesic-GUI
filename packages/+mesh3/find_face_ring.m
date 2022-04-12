function [ffring, vvring, vfring] = find_face_ring(v, f, k)
% FIND_FACE_RING finds the face k-ring of all faces of a triangle mesh
%
% Author: Lucas Pagliosa and Paulo Pagliosa
% Last revision: 27/05/2017
%
% Input
% =====
% V: nv x 3 matrix with the coordinates of the nv vertices of the mesh.
% F: nf x 3 matrix with the connectivity of the nf triangles of the mesh.
% K: topological radius of the ring.
%
% Output
% ======
% FFRING: 1 x nf cell array in which the i-th cell is a vector with the
%         indices of the face in F belonging to the face k-ring of
%         the i-th face of the mesh (i IS IN the face k-ring).
% VVRING: 1 x nv cell array in which the i-th cell is a vector with the
%         indices of the vertices in V belonging to the vertex 1-ring
%         of the i-th vertex of the mesh.
% VFRING: 1 x nv cell array in which the i-th cell is a vector with the
%         indices of the faces in F belonging to the face 1-ring of the
%         i-th vertex of the mesh (i IS NOT IN the vertex 1-ring).
%
% See also
% ========
% mesh3.FIND_VERTEX_RING

[vvring, vfring] = mesh3.find_vertex_ring(v, f);
fprintf('Computing face 1-ring...\n');
tic;
nf = size(f, 1);
ffring{nf} = [];
for m = 1 : nf
  face = f(m, :);
  u = union(union(vfring{face(1)}, vfring{face(2)}), vfring{face(3)});
  ffring{m} = u;%setdiff(u, i);
end
toc;
if nargin < 3 || k < 1
  return;
end
fprintf('Computing face %d-ring...\n', k);
tic;
ffring_1 = ffring;
for m = 1 : nf
  r = ffring_1{m};
  ffring_k = util.Queue;
  ffring_k.add(r);
  visited = false(nf, 1);
  visited(m) = true;
  visited(r) = true;
  for i = 2 : k
    ffring{m} = union(ffring{m}, [ffring_1{ffring_k.toArray}]);
    ffring_n = util.Queue;
    while ffring_k.size > 0
      r = ffring_1{ffring_k.remove};
      s = length(r);
      for j = 1 : s
        f = r(j);
        if ~visited(f)
          visited(f) = true;
          ffring_n.add(f);
        end
      end
    end
    if ffring_n.size == 0
      break;
    end
    ffring_k = ffring_n;
  end
end
toc;
