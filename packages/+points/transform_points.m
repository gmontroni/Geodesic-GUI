function p = transform_points(p, M)
% TRANSFORM_POINTS transforms a n-dimensional point set
%
% Author: Paulo A. Pagliosa
% Last revision: 08/09/2012
%
% Input
% =====
% P: np x n coordinates of the point set to be transformed.
% M: n-dimensional homogeneous transformation matrix.
%
% Output
% ======
% P: np x n coordinates of the transformed points.

[np, n] = size(p);
d = n + 1;
if size(M) ~= d
  error('M must ba a %dx%d matrix', d, d);
end
for i = 1 : np
  x = M * [p(i, :)'; 1];
  p(i, :) = x(1 : n)' / x(d);
end
