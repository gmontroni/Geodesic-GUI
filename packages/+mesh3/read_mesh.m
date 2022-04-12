function [v, f, name] = read_mesh(filename)
% READ_MESH reads a mesh from file
%
% Author: Paulo A. Pagliosa
% Last revision: 07/09/2012
%
% Input
% =====
% FILENAME: file from which the mesh is read.
%
% Output
% ======
% V: nv x 3 matrix with the 3D coordinates of the nv vertices of the mesh.
% F: nf x 3 matrix with the connectivity of the nf faces of the mesh.
% NAME: name of the mesh (filename without extension).
%
% Description
% ===========
% Reads a mesh from file named FILENAME. The mesh formats supported are
% PLY, OFF, and SMF. This function uses the readers and writers available
% in TOOLBOX_GRAPH by Gabriel Peyré.
%
% See also
% ========
% TOOLBOX_GRAPH

formats = {'.off', '.ply', '.smf', '.obj'};
nformats = length(formats);
[path, name, ext] = fileparts(filename);
if isempty(ext)
  for i = 1 : nformats
    if exist([filename formats{i}], 'file')
      ext = formats{i};
      filename = fullfile(path, [name ext]);
      break;
    end
  end
end
if isempty(ext) || ~exist(filename, 'file')
  error('Mesh file not found');
end
readers = {@read_off, @read_ply, @read_smf, @read_obj};
for i = 1 : nformats
  if strcmp(ext, formats{i})
    [v, f] = readers{i}(filename);
    return;
  end
end
error('Unknown mesh format: ''%s''', ext);
