clear all;

%name = 'sphere_01k.ply';
%name = 'sphere_02k.ply';
%name = 'sphere_04k.ply';
%name = 'sphere_08k.ply';
name = 'sphere_16k.ply';
%name = 'sphere_06_nu.ply';

options.symmetrize = 0;
options.normalize = 0;
laplacian_type = 'conformal' ;

%[vertex,face] = read_mesh(name);
mesh = readPLYfile(name);

L = compute_mesh_laplacian(mesh.vertices,mesh.triangles,laplacian_type,options);

%% Compute laplacian of f(x,y,z) = x ( = -2x )
n =  length(mesh.vertices);
Pos = zeros(n,3);
theta = 3.6;
R = [cos(theta) 0 -sin(theta) ; 0 1 0 ; sin(theta) 0 cos(theta)];
for i=1:n
    x =  mesh.vertices(i,1);
    y =  mesh.vertices(i,2);
    z =  mesh.vertices(i,3);
    Pos(i,:) = R*[x y z]';
    mesh.vertices(i,:) = Pos(i,:);
end

tst = 3;
if ( tst == 1) % f(x,y,z) = x
    disp('Function: f(x,y,z) = x');
    f = Pos(:,1);
    Lf = -2*f;
elseif ( tst == 2) % f(x,y,z) = x^2
    disp('Function: f(x,y,z) = x^2');
    T = Pos.^2;
    f = T(:,1);
    Lf = (4*T(:,1).*T(:,3)-2*(T(:,1)-T(:,2)))./(T(:,1)+T(:,2)) - 2*T(:,1);
elseif (tst==3) % f(x,y,z) = exp(x)
    disp('Function: f(x,y,z) = exp(x)');
    T = Pos(:,1).^2;
    f = exp(Pos(:,1));
    Lf = (1-2*Pos(:,1)-T(:,1)).*exp(Pos(:,1));
end
 Lf_app = -L*f;

erro_l2   = norm(Lf_app - Lf)/norm(Lf);
erro_linf = norm(Lf_app - Lf,inf)/norm(Lf,inf);

fprintf(1,'Error L2-norm = %.5f\n',erro_l2); 
fprintf(1,'Error Linf-norm = %.5f\n',erro_linf); 

%% Performing eigendecomposition
% [eigenvector, eigenvalue] = eigs(L,10,'LM');
% eigenvector = real(eigenvector);
% eigenvalue = real(eigenvalue);
%[lam,ix] = sort(diag(eigenvalue));
%eigenvector = eigenvector(:,ix); %sorted columns

% Luo et al., Approximating Gradients for Meshes and Point Clouds via
% Diffusion Metric
% Neigs = 10;
% Npts = length(mesh.vertices);
% AW = compute_mesh_voronoi_area(mesh.vertices,mesh.triangles);
% invD = sparse(1:Npts, 1:Npts, AW);
% S = invD*L;
% [eigenvector, eigenvalue] = eigs(S, invD, Neigs, -1e-4);
% eigenvalue = diag(eigenvalue);
% 
% if eigenvalue(1) > eigenvalue(end)
%     eigenvalue = eigenvalue(Neigs:-1:1);
%     eigenvector = eigenvector(:, Neigs:-1:1);
% end
% 
% for i = 1:Neigs
%     eigenvector(:,i) = eigenvector(:,i).*AW;
% end

% extract one of the eigenvectors
% c = eigenvector(:,1); % you can try with other vector with higher frequencies
% 
% clf
% subplot(1,2,1);
% drawPLY(mesh,Lf_app);
% colorbar;
% subplot(1,2,2);
% drawPLY(mesh,c);
% colorbar;