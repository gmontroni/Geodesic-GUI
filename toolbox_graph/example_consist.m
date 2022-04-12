clear all;

FILES = {'sphere_01k.ply' 'sphere_02k.ply' 'sphere_04k.ply' 'sphere_08k.ply' 'sphere_16k.ply' 'sphere_06k_nu.ply'};
name=FILES{6};
fprintf(1,'model = %s;\n',name);

%[vertex,face] = read_mesh(name);
[mesh,Pos] = load_mesh(name);

options.symmetrize = 0;
options.normalize  = 0;
laplacian_type = 'conformal' ;
L = compute_mesh_laplacian(mesh.vertices,mesh.triangles,laplacian_type,options);

for i=1:3
    [f,Lf] = function_eval(Pos,i);
    Lf_app = -L*f;
    
    erro_l2   = norm(Lf_app - Lf)/norm(Lf);
    erro_linf = norm(Lf_app - Lf,inf)/norm(Lf,inf);

    fprintf(1,'Error L2-norm = %.5f\n',erro_l2); 
    fprintf(1,'Error Linf-norm = %.5f\n\n',erro_linf); 
end