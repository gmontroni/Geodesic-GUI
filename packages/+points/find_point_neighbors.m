function [nidx, dist] = find_point_neighbors(p, points, r)
% FIND_POINT_NEIGHBORS finds the neighbors of a n-dimensional point
%
% Author: Paulo A. Pagliosa
% Last revision: 23/05/2017
%
% Input
% =====
% P: 1 x n coordinates of the point.
% POINTS: np x n point set.
% R: search radius.
%
% Output
% ======
% NIDX: indices of neighbors of P in POINTS.
% DIST: Euclidean distances between P and each one of its neighbors.
%
% Description
% ===========
% Given the coordinates of a point set POINTS and of a point P in a
% n-dimensional space, and a radius R, this function finds all the
% points in POINTS whose distance to P is less than R. The indices
% of the neighbors of P in POINTS and the distance between P and its
% neighbors are returned in NIDX and DIST, respectively.

r2 = r * r;
[np, dim] = size(points);
nidx = 1 : np;
inside = true(np, 1);
for i = 1 : dim
  inside = inside & abs(points(:, i) - p(i)) < r;
end
nidx = nidx(inside);
q = points(nidx, :);
dist = zeros(length(nidx), 1);
for i = 1 : dim
  dist = dist + (q(:, i) - p(i)) .^ 2;
end
inside = dist < r2;
nidx = nidx(inside);
if nargout == 2
  dist = sqrt(dist(inside));
else
  dist = [];
end
