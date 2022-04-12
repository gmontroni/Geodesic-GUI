function [hit, info] = find_ray_mesh_intersections(v, f, N, ray, all)
% FIND_RAY_MESH_INTERSECTION finds ray/triangular mesh intersections
%
% Author: Paulo A. Pagliosa
% Last revision: 08/09/2012
%
% Input
% =====
% V: nv x 3 matrix with the coordinates of the nv vertices of the mesh.
% F: nf x 3 matrix with the connectivity of the nf triangles of the mesh.
% N: nf x 3 matrix with the coordinates of the nf face normals.
% RAY: struct with two fields: O and D. O is a 1 x 3 vector with the
%      coordinates of the origin of the ray. D is a 1 x 3 vector with
%      the coordinates of the direction of the ray.
% ALL: if true, finds all intersections of RAY with the mesh. Otherwise,
%      finds the closest intersection with the origin og the ray
%
% Output
% ======
% HIT: number of intersections of RAY with the mesh.
% INFO: a vector of structs where each struct contains info about one
%       intersection of RAY with the mesh. The info struct has four
%       fields: TRIANGLE (the index of the triangle in F), DISTANCE
%       (the distance between the origin of RAY and the intersection
%       point on TRIANGLE), P (1 x 3 vector with the coordinates of
%       the intersection point), and U (1 x 3 vector with the
%       barycentric coordinates of P).

hit = 0;
info = setInfo([], inf, [], []);
nf = size(f, 1);
for i = 1 : nf
  v1 = v(f(i, 1), :);
  v2 = v(f(i, 2), :);
  v3 = v(f(i, 3), :);
  [t_hit, t, p, u] = intersect_triangle(v1, v2, v3, N(i, :), ray);
  if t_hit
    if all
      hit = hit + 1;
      info(hit) = setInfo(i, t, p, u);
      k = hit;
      while k > 1
        j = k - 1;
        if info(k).distance >= info(j).distance
          break;
        end
        t = info(k);
        info(k) = info(j);
        info(j) = t;
        k = j;
      end
    elseif t < info.distance
      hit = 1;
      info.triangle = i;
      info.distance = t;
      info.p = p;
      info.u = u;
    end
  end
end


% --- Intersection info.
function info = setInfo(t, d, p, u)
info = struct('triangle', t, 'distance', d, 'p', p, 'u', u);


% --- Ray/triangle intersection.
function [hit, t, p, u] = intersect_triangle(v1, v2, v3, N, ray)

hit = 0; t = 0; p = [NaN, NaN, NaN]; u = p;
eps = 1.e-6;
d = inner(ray.d, N);
if abs(d) < eps
  return;
end
t = -inner(ray.o - v1, N) / d;
if t <= eps
  return;
end
p = make_ray_point(ray, t);

% Find the normal dominant axis
dominantAxis = 1; 
if abs(N(2)) > abs(N(1))
  dominantAxis = 3;
end
if abs(N(3)) > abs(N(dominantAxis))
  dominantAxis = 3;
end

b = eliminate_dominant([v2 - v1; v3 - v1; p - v1], dominantAxis);
d = 1 / (b(1, 2) * b(2, 1) - b(1, 1) * b(2, 2));

u(1) = (b(3, 2) * b(2, 1) - b(3, 1) * b(2, 2)) * d;
u(2) = (b(3, 1) * b(1, 2) - b(3, 2) * b(1, 1)) * d;
u(3) = 1 - (u(1) + u(2));
if u(1) >= 0 && u(2) >= 0 && u(3) >= 0
  hit = 1;
end


% --- Inner product.
function c = inner(a, b)
c = sum(a .* b);


% --- Make point on a ray.
function p = make_ray_point(ray, t)
% make_ray_point
p = ray.o + ray.d * t;


% --- Project point by eliminating normal dominant coordinate.
function p = eliminate_dominant(p, dominantAxis)
% eliminate_dominant
if dominantAxis == 1
  p(:, 1) = p(:, 3);
elseif dominantAxis == 2
  p(:, 2) = p(:, 3);
end
