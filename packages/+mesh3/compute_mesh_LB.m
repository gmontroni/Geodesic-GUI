function L = compute_mesh_LB(v, f)
% compute_mesh_LB
% TODO: detailed explanation

options.symmetrize = 0; options.normalize = 0;
options.verb = 0;
laplacian_type = 'levy';
L = compute_mesh_laplacian(v, double(f), laplacian_type, options);
