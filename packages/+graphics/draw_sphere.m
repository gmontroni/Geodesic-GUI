function h = draw_sphere(axes, center, r, color, alpha)
% DRAW_SPHERE plots a sphere
%
% Author: Paulo A. Pagliosa
% Last revision: 15/06/2012
%
% Input
% =====
% AXES: axes in which the sphere is plotted.
% CENTER: [x y z] center of the sphere
% R: radius of the sphere.
% COLOR: color of the sphere.
% ALPHA: [0..1] transparency of the sphere (1 is fully opaque).
%
% Output
% ======
% H: handle to the surface plot object.

[x, y, z] = sphere;
h = surf(axes, center(1) + r * x, center(2) + r * y, center(3) + r * z);
set(h, 'EdgeColor', 'none', 'FaceColor', color, 'FaceAlpha', alpha);
