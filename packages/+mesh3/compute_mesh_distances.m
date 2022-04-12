function A = compute_mesh_distances(v, f, dtype, maxd)
% compute_mesh_distances
% TODO: detailed explanation

if nargin < 3
  dtype = 'geodesic';
end
if nargin < 4
  maxd = inf;
end
disp('Computing dual mesh weights...');
tic;
A = mesh3.compute_mesh_weights(v, f, dtype);
toc;
if maxd == 1
  return;
end;
disp('Computing all shortest paths...');
tic;
n = size(A, 1);
if exist('perform_dijkstra_fast', 'file') == 3
  A = perform_dijkstra_fast(A, 1 : n, maxd);
else
  A = full(A);
  A(A == 0) = inf;
  for i = 1 : n
    A(i, i) = 0;
  end
  G = zeros(n, n);
  % compute shortest path
  for p = 1 : n
    v = false(n, 1);
    d = A(p, :);
    v(p) = true;
    for i = 2 : n
      min = inf;
      u = -1;
      for j = 1 : n
        if ~v(j) && d(j) < min
          min = d(j);
          u = j;
        end
      end
      if min >= maxd
        break;
      end
      v(u) = true;
      for j = 1 : n
        if ~v(j)
          dw = d(u) + A(u, j);
          if dw < d(j)
            d(j) = dw;
          end
        end
      end
    end
    G(p, :) = d;
  end
  A = (G + G') / 2;
end
toc;
