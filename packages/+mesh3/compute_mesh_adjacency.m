function A = compute_mesh_adjacency(v, f)
% COMPUTE_MESH_ADJACENCY computes the adjacency matrix of a triangle mesh
%
% Author: Paulo A. Pagliosa
% Last revision: 08/09/2012
%
% Input
% =====
% V: nv x 3 matrix with the coordinates of the nv vertices of the mesh.
% F: nf x 3 matrix with the connectivity of the nf triangles of the mesh.
%
% Output
% ======
% A: nv x nv adjacency matrix.
%
% Description
% ===========
%
% COMPUTE_MESH_ADJACENCY computes the sparse adjacency matrix A of a
% triangle mesh whose vertices and faces are V and F, respectively.
% A(i, j) is nonzero if there is any face in F that connects the vertices
% i e j in V.

n = size(v, 1);
i = [f(:, 1); f(:, 1); f(: ,2); f(:, 2); f(:, 3); f(:, 3)];
j = [f(: ,2); f(:, 3); f(:, 1); f(:, 3); f(: ,1); f(:, 2)];
A = sparse(i, j, 1, n, n);
A = double(A > 0);
