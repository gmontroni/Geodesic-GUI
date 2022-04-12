function [A, c] = compute_dual_graph(v, f, vfring)
% COMPUTE_DUAL_GRAPH computes the dual graph of a mesh
%
% Author: Lucas Pagliosa and Paulo Pagliosa
% Last revision: 22/05/2017
%
% Input
% =====
% V: nv x 3 matrix with the coordinates of the nv vertices of the mesh.
% F: nf x 3 matrix with the connectivity of the nf triangles of the mesh.
% VFRING: optional cell array with the vertex face ring of the mesh.
%
% Output
% ======
% A: nf x nf adjancency matrix of the dual graph.
% C: optional nf x 3 matrix with the coordinates of the dual vertices.
%
% Description
% ===========
% A dual graph D of a mesh M is a graph such that each vertex in D
% corresponds to a face in M, being the vertex position the the centroid
% of the corresponding face. An edge connects two vertices v1 and v2 in D
% if the corresponding faces in M are neighbors. The function returns
% the adjacency matrix and the vertices of D.
%
% See also
% ========
% FIND_VERTEX_RING, COMPUTE_MESH_CENTROIDS

narginchk(2, 3);
if nargin < 3
  [~, vfring] = mesh3.find_vertex_ring(v, f);
end
disp('Computing graph adjacency...');
tic;
nf = size(f, 1);
A = zeros(nf);
for i = 1 : nf
  A(i, dual_face(f(i, :), vfring)) = 1;
end
A = sparse(A - eye(nf));
toc;
if nargout == 1
  c = [];
  return;
end
disp('Computing face centroids...');
tic;
c = mesh3.compute_mesh_centroids(v, f);
toc;

function df = dual_face(f, vfring)
r1 = vfring{f(1)};
r2 = vfring{f(2)};
r3 = vfring{f(3)};
df = [intersect(r1, r2), intersect(r2, r3), intersect(r3, r1)];
