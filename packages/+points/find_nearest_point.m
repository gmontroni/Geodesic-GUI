function [nidx, dist] = find_nearest_point(p, points)
% FIND_NEAREST_POINT finds in a set the nearest point to a given point
%
% Author: Paulo A. Pagliosa
% Last revision: 08/09/2012
%
% Input
% =====
% points: np x 3 matrix with the coordinates of np points.
% P: 1 x 3 vector with the coordinates of a point.
%
% Output
% ======
% NIDX: index in POINTS of the nearest point to P.
% DIST: Euclidian distance between P and the nearest point.

[np, dim] = size(points);
dist = zeros(np, 1);
for i = 1 : dim
  dist = dist + (points(:, i) - p(i)) .^ 2;
end
[dist, nidx] = min(dist);
dist = sqrt(dist);
