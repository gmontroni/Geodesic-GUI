function h = render_mesh(axes, f, v, face_color)
% RENDER_MESH creates a patch from a mesh
%
% Author: Paulo A. Pagliosa
% Last revision: 07/09/2012
%
% Input
% =====
% AXES: axes in which the patch is added.
% V: nv x 3 matrix with the 3D coordinates of the nv vertices of the mesh.
% F: nf x 3 matrix with the connectivity of the nf faces of the mesh.
% FACE_COLOR: color of the faces of the patch.
%
% Output
% ======
% H: handle to the patch object.

if nargin < 4 || isempty(face_color)
  h = patch('Parent', axes, ...
    'Vertices', v, ...
    'Faces', f, ...
    'CData', v(:, end), ...
    'FaceColor', 'interp');
else
  h = patch('Parent', axes, ...
    'Vertices', v, ...
    'Faces', f, ...
    'FaceColor', face_color);
end
