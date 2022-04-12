function h = render_mesh_face(axes, mesh, fid, color, alpha)
% RENDER_MESH_FACE creates a patch from mesh faces
%
% Author: Lucas Pagliosa and Paulo Pagliosa
% Last revision: 23/05/2017
%
% Input
% =====
% AXES: axes in which the patch is added.
% MESH: an instance of TriMesh.
% FID: face indices.
% COLOR: color of the face.
% ALPHA: alpha value of the face color.
%
% Output
% ======
% H: handle to the patch object.

h = patch('Parent', axes, ...
  'Vertices', mesh.vertex(:), ...
  'Faces', mesh.face(fid), ...
  'FaceColor', color, ...
  'FaceAlpha', alpha);
