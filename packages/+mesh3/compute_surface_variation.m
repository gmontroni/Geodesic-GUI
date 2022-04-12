function sv = compute_surface_variation(v, f, vring)
% COMPUTE_MESH_SURFACE_VARIATION computes the surface variation of the
% vertices of a mesh
%
% Author: Lucas Pagliosa and Paulo Pagliosa
% Last revision: 23/05/2017
%
% Input
% =====
% V: nv x 3 matrix with the coordinates of the nv vertices of the mesh.
% F: nf x 3 matrix with the connectivity of the nf triangles of the mesh.
% VRING: 1 x nv cell array in which the i-th cell is a vector with the
%        indices of the vertices in V belonging to the vertex k-ring
%        of the i-th vertex of the mesh.
% 
% Output
% ======
% SV: nv x 1 vector with the surface variation of every mesh vertex.
%
% See also
% ========
% FIND_VERTEX_RING

narginchk(2, 3);
if nargin < 3
  vring = mesh3.find_vertex_ring(v, f);
end
nv = size(v, 1);
sv = zeros(nv, 1);
for i = 1 : nv
  lambda = eig(covariance(v(vring{i}, :)));
  sv(i) = min(lambda) / sum(lambda);
end

function c = covariance(p)
m = size(p, 1);
centroid = sum(p, 1) / m;
c = p - repmat(centroid, m, 1);
c = c' * c;
