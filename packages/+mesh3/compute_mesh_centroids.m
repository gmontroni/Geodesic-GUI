function c = compute_mesh_centroids(v, f)
% COMPUTE_MESH_CENTROIDS computes the centroids of all faces of a mesh 
%
% Author: Lucas C. Pagliosa
% Last revision: 11/09/2012
%
% Input
% =====
% V: nv x 3 matrix with the coordinates of the nv vertices of the mesh.
% F: nf x 3 matrix with the connectivity of the nf triangles of the mesh.
%
% Output
% ======
% C: nf x 3 matrix with the coordinates of the centroids.
%
% Description
% ===========
% Let be a triangular face defined by the vertices (v1, v2, v3). The
% coordinates of the centroid of the face are (v1 + v2 + v3) / 3. For
% example, let be the face given by the vertices v1(1, 2, 4), v2(5, 6, -1),
% and v3(-3, 3, -5). The centroid c of the face is:
%   c(1) = (1 + 5 + (-3)) / 3 = 1,
%   c(2) = (2 + 6 + 3) / 3 = 3.66,
%   c(3) = (4 + (-1) + (-5)) / 3 = -0.66.

c = (v(f(:, 1), :) + v(f(:, 2), :) + v(f(:, 3), :) ) / 3;
