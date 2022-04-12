function radius = compute_vertex_ring_radius(v, vring)
% COMPUTE_VERTEX_RING_RADIUS computes the radius of the vertex rings of a
% mesh
%
% Author: Paulo Pagliosa
% Last revision: 24/05/2017
%
% Input
% =====
% V: nv x 3 matrix with the coordinates of the nv vertices of the mesh.
% VRING: 1 x nv cell array in which the i-th cell is a vector with the
%        indices of the vertices in V belonging to the vertex k-ring
%        of the i-th vertex of the mesh.
%
% Output
% ======
% RADIUS: nv x 1 vector with the radius of the vring radius.

nv = size(v, 1);
radius = zeros(nv, 1);
for i = 1 : nv
  radius(i) = max(norm(v(i, :), v(vring{i}, :)));
end
radius = sqrt(radius);

function d = norm(c, p)
d = (p(:, 1) - c(1)) .^ 2 + (p(:, 2) - c(2)) .^ 2 + (p(:, 3) - c(3)) .^ 2;
