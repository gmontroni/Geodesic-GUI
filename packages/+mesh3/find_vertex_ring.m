function [vring, fring] = find_vertex_ring(v, f, k)
% FIND_VERTEX_RING finds the k-ring of all vertices of a triangle mesh
%
% Author: Paulo A. Pagliosa
% Last revision: 15/05/2017
%
% Input
% =====
% V: nv x 3 matrix with the coordinates of the nv vertices of the mesh.
% F: nf x 3 matrix with the connectivity of the nf triangles of the mesh.
% K: topological radius of the ring.
%
% Output
% ======
% VRING: 1 x nv cell array in which the i-th cell is a vector with the
%        indices of the vertices in V belonging to the vertex k-ring
%        of the i-th vertex of the mesh.
% FRING: 1 x nv cell array in which the i-th cell is a vector with the
%        indices of the faces in F belonging to the face k-ring of the
%        i-th vertex of the mesh.
%
% See also
% ========
% COMPUTE_MESH_ADJACENCY, util.Queue

nv = size(v, 1);
if nargin < 3 || k < 1 || k > nv
  k = 1;
end
disp('Computing mesh adjacency...');
tic;
A = mesh3.compute_mesh_adjacency(v, double(f));
toc;
disp('Computing vertex 1-ring...');
tic;
[i, j] = find(A);
vring{nv} = [];
s = length(i);
for m = 1 : s
  vring{i(m)}(end + 1) = j(m);
end
if nargout == 2
  fring{nv} = [];
  nf = size(f, 1);
  for i = 1 : nf
    for j = 1 : 3
      fring{f(i, j)}(end + 1) = i;
    end
  end
end
toc;
if k == 1
  return;
end
fprintf('Computing vertex %d-ring...\n', k);
tic;
vring_1 = vring;
if nargout == 2
  fring_1 = fring;
end
for m = 1 : nv
  r = vring_1{m};
  vring_k = util.Queue;
  vring_k.add(r);
  visited = false(nv, 1);
  visited(m) = true;
  visited(r) = true;
  for i = 2 : k
    if nargout == 2
      fring{m} = union(fring{m}, [fring_1{vring_k.toArray}]);
    end
    vring_n = util.Queue;
    while vring_k.size > 0
      r = vring_1{vring_k.remove};
      s = length(r);
      for j = 1 : s
        v = r(j);
        if ~visited(v)
          visited(v) = true;
          vring_n.add(v);
        end
      end
    end
    if vring_n.size == 0
      break;
    end
    vring{m} = union(vring{m}, vring_n.toArray);
    vring_k = vring_n;
  end
end
toc;
