function L = compute_Tutte_Laplacian(v, f)
% COMPUTE_TUTTE_LAPLACIAN computes Tutte Laplacian on a mesh
%
% Author: Paulo A. Pagliosa
% Last revision: 19/05/2017
%
% Input
% =====
% V: nv x 3 matrix with the coordinates of the nv vertices of the mesh.
% F: nf x 3 matrix with the connectivity of the nf triangles of the mesh.
%
% A: nv x nv adjacency matrix of the mesh.
%
% Output
% ======
% L: Tutte Laplacian matrix.
%
% Description
% ===========
% COMPUTE_TUTTE_LAPLACIAN computes the Tutte Laplacian L on the mesh
% defined by the vertices V and faced F. Let E be the set of edges of the
% mesh defined by pair of vertices (i, j). L is a nv x nv sparse matrix
% given by
%            { 1, if i = j,
%   L_{ij} = { -1 / d_i, if (i, j) \in E, and
%            { 0, otherwise,
% where d_i is the number of the neighbors in the 1-ring of the vertex i.
% If 
%
% See also
% ========
% COMPUTE_MESH_ADJACENCY

narginchk(1, 2);
if nargin == 1
  A = v;
else
  A = mesh3.compute_mesh_adjacency(v, double(f));
end
L = speye(size(A, 1)) - diag(sum(A, 1) .^ (-1)) * A;
