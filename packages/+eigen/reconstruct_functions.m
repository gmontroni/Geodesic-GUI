function F = reconstruct_functions(V, A)
% reconstruct_functions

% Reconstruct scalar functions F from coefficients A resulting from
% projection of F in an eigenspace whose eigenfunctions are represented
% by orthonormal eigenvectors V. V is a Nxd real matriz, where N is the
% number of discrete points at which eingenfunctions are available (for
% example, vertices on a surface mesh), and d <= N is the eigenspace
% dimension (ie, V(i, j) is the value of the eigenfunction j at the
% point i). A is a Kxf real matrix, where K <= d is the number of
% eigenvectors used for projection, and f is the number of functions
% (ie, A(i, j) is the coefficient of the function j regarding the
% eigenfunction i).
%
% Output F is a Nxf real matrix.

[N, d] = size(V);
[K, f] = size(A);
if K > d
  error('A must have number of rows between 1 and %d', d);
end

% Allocate function matrix
F = zeros(N, f);

% Reconstruct functions
for d = 1 : f
  for c = 1 : K
    F(:, d) = F(:, d) + A(c, d) * V(:, c);
  end
end
