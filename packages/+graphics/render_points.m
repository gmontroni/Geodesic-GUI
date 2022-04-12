function h = render_points(axes, p, color, marker, point_size)
% RENDER_POINTS plots points
%
% Author: Paulo A. Pagliosa
% Last revision: 05/09/2012
%
% Input
% =====
% AXES: axes in which the points are plotted.
% P: np x 2 or np x 3 matrix with the coordinates of the points.
% COLOR: single color (for all points) or np colors (one for each point).
% MARKER: type of the points.
% POINT_SIZE: size of the points (default = 5).
%
% Output
% ======
% H: handle to the hggroup plot object.
%
% Remarks
% =======
% RENDER_POINTS is similar to RENDER_MARKER but allows to specify a
% different color to each marker. Use RENDER_MARKER for single color.
%
% See also
% ========
% RENDER_MARKER

if nargin < 5
  point_size = 5;
end
if size(p, 2) == 2
  h = scatter(axes, ...
    p(:, 1), ...
    p(:, 2), ...
    point_size .^ 2, ...
    color, ...
    marker, ...
    'filled');
else
  h = scatter3(axes, ...
    p(:, 1), ...
    p(:, 2), ...
    p(:, 3), ...
    point_size .^ 2, ...
    color, ...
    marker, ...
    'filled');
end
