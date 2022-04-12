function A = project_functions(V, F, K)
% project_functions
%
% Get the first K coefficients of scalar functions F projected in an
% eigenspace whose eigenfunctions are represented by orthonormal
% eigenvectors V. V is a Nxd real matriz, where N is the number of
% discrete points at which eingenfunctions are available (for example,
% vertices on a surface mesh), and d <= N is the eigenspace dimension
% (ie, V(i, j) is the value of the eigenfunction j at the point i).
% F must be a Nxf real matrix, where f is the number of functions. Each
% function to be projected is a column of F (ie, F(i, j) is the value of
% the function j at the point i). K must be an integer <= d.
%
% Output A is a Kxf real matrix.

% Check input arguments
narginchk(2, 3);
[N, d] = size(V);
[c, f] = size(F);
if c ~= N
  error('V and F must have same number of rows');
end
if nargin == 2
  K = d;
elseif K < 1 || K > d
  error('K must be an integer between 1 and %d', d);
end

% Allocate coefficient matrix
A = zeros(K, f);

% For each column in F, compute the first K coefficients
for d = 1 : f
  for c = 1 : K
    A(c, d) = sum(F(:, d) .* V(:, c));
  end
end
