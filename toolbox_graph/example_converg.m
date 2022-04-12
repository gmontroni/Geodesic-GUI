clear all;

name = 'sphere_01k.ply';
%name = 'sphere_02k.ply';
%name = 'sphere_04k.ply';
%name = 'sphere_08k.ply';
%name = 'sphere_16k.ply';
%name = 'sphere_06_nu.ply';
fprintf(1,'model = %s\n',name);

%[vertex,face] = read_mesh(name);
[mesh,Pos] = load_mesh(name);
[f,Lf] = function_eval(Pos,1);

options.symmetrize = 0;
options.normalize  = 0;
laplacian_type = 'conformal' ;
L = compute_mesh_laplacian(mesh.vertices,mesh.triangles,laplacian_type,options);

options.symmetrize = 0;
options.normalize = 0;
laplacian_type = 'conformal' ;
Ltemp = compute_mesh_laplacian(mesh.vertices,mesh.triangles,laplacian_type,options);

lambda = [0 1 10 100];
for l=1:4
    [u,b] = edp(Pos,1,1,1,lambda(l));
    L = Ltemp + lambda(l)*eye(Npts);

    % SPH Laplace solution
    pen = 1e+8;
    dc = 1;
    nc = length(dc);
    bc = zeros(nc,1);
    Lc = zeros(nc,Npts);
    for i=1:nc
        Lc(i,dc(i)) = pen;
        bc(i) = pen*u(dc(i));
    end
    LL = [L;Lc];
    bb = [b;bc];

    if ( 1 ) % Tychonov
        rho = 1e-5;
        nc = length(bb);
        D = rho * speye(nc,Npts);
        z = zeros(nc,1);
        LL = [LL;D];
        bb = [bb;z];
    end

    LLL = LL'*LL;
    bbb = LL'*bb;

    sol = LLL\bbb;

    Erro = abs(sol-u) ;

    %%=============================
    fprintf(1,'lambda= %3.1f\n Error L2-norm = %.8f\n',lambda(l),norm(Erro)/norm(u)); 
    fprintf(1,'Error Linf-norm = %.8f\n\n',norm(Erro,inf)/norm(u,inf));
end
