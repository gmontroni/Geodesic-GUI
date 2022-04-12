function ray = create_ray(origin, direction)
% CREATE_RAY creates one ray with origin at ORIGIN and direction
% pointing at DIRECTION.

% Author: Lucas C. Pagliosa
% Last revision: 28/11/2012
%
% Input
% =====
% ORIGIN: 3 x 1 point.
% DIRECTION: 3 x 1 point.
% 
% Output
% ======
% RAY: struct containing ray's origin and direction.
%

ray.origen = origin;
ray.direction = direction;
