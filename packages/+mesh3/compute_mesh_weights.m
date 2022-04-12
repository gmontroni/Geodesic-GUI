function A = compute_mesh_weights(v, f, dtype)
% compute_mesh_weights
% TODO: detailed explanation

if nargin < 3
  dtype = 1;
else
  switch lower(dtype)
    case 'geodesic'
      dtype = 1;
    case 'topological'
      dtype = 2;
    otherwise
      error('unknown distance type');
  end
end
n = size(v, 1);
A = mesh3.compute_mesh_adjacency(v, double(f));
if dtype == 1
  [i, j] = find(A);
  d = v(i, :) - v(j, :);
  d = sqrt(sum(d .* d, 2));
  d = sparse(i, j, d, n, n);
  A = A .* d;
end
