function [V, D] = eigendecomposition(L, n)
% eigendecomposition
% TODO: detailed description

if issparse(L)
  if n < size(L, 1)
    opts.tol = 1e-12;
    [V, D] = eigs(L, n, 'sm', opts);
    D = flipud(diag(D));
    % Eigenvectors are the columns of V
    V = fliplr(V);
    return;
  end
  L = full(L);
end
[V, D] = eig(L);
D = diag(D);
