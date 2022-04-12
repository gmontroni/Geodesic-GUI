function N = compute_face_normals(v, f)
% COMPUTE_FACE_NORMALS computes face normals of a 2D polygon or 3D mesh
%
% Author: Paulo A. Pagliosa
% Last revision: 08/09/2012
%
% Input
% =====
% V: nv x dim matrix with the coordinates of the nv vertices of the
%    polygon (dim = 2) or mesh (dim = 3).
% F: nf x dim matrix with the connectivity of the nf edges of the
%    polygon (dim - 2) or faces of the mesh (dim = 3).
%
% Output
% ======
% N: nf x dim matrix with the coordinates of the nf normals of the
%    edges of the polygon (dim = 2) or faces of the mesh (dim = 3).

dim = size(v, 2);
if dim == 2
  N = cross2(v(f(:, 2), :) - v(f(:, 1), :));
else
  N = cross3(v(f(:, 2), :) - v(f(:, 1), :), v(f(:, 3), :) - v(f(:, 1), :));
end
d = sqrt(sum(N .^ 2, 2));
d(d < eps) = 1;
N = N ./ repmat(d, 1, dim);

% 2D "cross product"
function c = cross2(a)
c = [a(:, 2), -a(:, 1)];

% Cross product
function c = cross3(a, b)
c = a;
c(:, 1) = a(:, 2) .* b(:, 3) - a(:, 3) .* b(:, 2);
c(:, 2) = a(: ,3) .* b(:, 1) - a(:, 1) .* b(:, 3);
c(:, 3) = a(:, 1) .* b(:, 2) - a(:, 2) .* b(:, 1);
