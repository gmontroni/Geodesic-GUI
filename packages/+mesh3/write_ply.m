function write_ply(v, f, filename)
% WRITE_PLY writes on a file indicated bt FILENAME the .ply representation
% of a mesh described by the vertices V and faces F.
%
% Author: Lucas C. Pagliosa
% Last revision: 18/09/2012
%
% Input
% =====
% V: nv x 3 matrix with the coordinates of the nv vertices of the mesh.
% F: nf x ns matrix with the connectivity of the nf faces of the mesh.
%    The face has ns sides. For exemple, a triangular face has ns = 3 while
%    a quad face has ns = 4.
% FILENAME: the path of the target file.

fid = fopen(filename, 'w');
nv = size(v, 1);
nf = size(f, 1);
ns = size(f, 2);
fprintf(fid, 'ply\nformat ascii 1.0\ncomment VCGLIB generated\n');
fprintf(fid, 'element vertex %d\n', nv);
fprintf(fid, 'property float x\nproperty float y\nproperty float z\n');
fprintf(fid, 'element face %d\n', nf);
fprintf(fid, 'property list uchar int vertex_indices\nend_header\n');
for i = 1:nv
  fprintf(fid, '%f %f %f\n', v(i, :));
end
for i = 1:nf
  fprintf(fid, '%d', ns);
  for j = 1:ns
    fprintf(fid, ' %d', f(i, j));
  end
  fprintf(fid, '\n');
end
fclose(fid);
