neigs = 100;
EIGScot  = zeros(neigs,6);
FILES = {'sphere_01k.ply' 'sphere_02k.ply' 'sphere_04k.ply' 'sphere_08k.ply' 'sphere_16k.ply' 'sphere_06k_nu.ply'};
for j=1:6
    name=FILES{j};
    fprintf(1,'model = %s;\n',name);
    
    [mesh,Pos] = load_mesh(name);
    
    options.symmetrize = 0;
    options.normalize  = 0;
    laplacian_type = 'levy';
    L = compute_mesh_laplacian(mesh.vertices,mesh.triangles,laplacian_type,options);
    
    opts.tol = 1e-5;
    [~,eigenvalues] = eigs(L, neigs, 'sm', opts);
    %[eigenvector,eigenvalues] = eigs(L, neigs, 'sm', opts);
    
    %%GENERALIZED (conformal)
    %%tirar a divisao por omega em compute_mesh_weight
    %%retornar omega
    %invW = diag(W); 
    %opts.tol = 1e-5;
    %[~,eigenvalues] = eigs(L, invW, neigs, 'sm', opts);
    %[eigenvector,eigenvalues] = eigs(L, invW, neigs, 'sm', opts);
    
    EIGScot(:,j) = flipud(diag(eigenvalues));
    %draw_eigs(mesh,eigenvector,3);
end