function [W,omega] = compute_mesh_weight(vertex,face,type,options)

% compute_mesh_weight - compute a weight matrix
%
%   W = compute_mesh_weight(vertex,face,type,options);
%
%   W is sparse weight matrix and W(i,j)=0 is vertex i and vertex j are not
%   connected in the mesh.
%
%   type is either 
%       'combinatorial': W(i,j)=1 is vertex i is conntected to vertex j.
%       'distance': W(i,j) = 1/d_ij^2 where d_ij is distance between vertex
%           i and j.
%       'conformal': W(i,j) = cot(alpha_ij)+cot(beta_ij) where alpha_ij and
%           beta_ij are the adjacent angle to edge (i,j)
%
%   If options.normalize=1, the the rows of W are normalize to sum to 1.
%
%   Copyright (c) 2007 Gabriel Peyre

options.null = 0;
[vertex,face] = check_face_vertex(vertex,face);

nface = size(face,1);
n = max(max(face));

if ( isfield(options, 'verb') )
    verb = options.verb;
else
    verb = n>5000;
end

if ( nargin < 3 )
    type = 'conformal';
end

switch lower(type)
    case 'combinatorial'
        W = triangulation2adjacency(face);
        
    case 'distance'
        W = my_euclidean_distance(triangulation2adjacency(face),vertex);
        W(W>0) = 1./W(W>0);
        W = (W+W')/2; 
        
    case 'conformal'
        % conformal laplacian
        W = sparse(n,n);
        omega = compute_mesh_voronoi_area(vertex,face);
        ring = compute_vertex_face_ring(face);
       
        for i = 1:n
            
            if verb
                progressbar(i,n);
            end
               
            for b = ring{i}
                % b is a face adjacent to a
                bf = face(:,b);
                % compute complementary vertices
                if bf(1)==i
                    v = bf(2:3);
                elseif bf(2)==i
                    v = bf([1 3]);
                elseif bf(3)==i
                    v = bf(1:2);
                else
                    error('Problem in face ring.');
                end
                j = v(1); k = v(2);
                vi = vertex(:,i);
                vj = vertex(:,j);
                vk = vertex(:,k);
              
                % angles
                alpha = myangle(vi-vj,vk-vj);
                beta = myangle(vi-vk,vj-vk);
                
                % cotangents
                ca = 0.5*cotan( alpha ) ;
                cb = 0.5*cotan( beta ) ;
                
                % add weight
                W(i,k) = W(i,k) - ca ;
                W(i,j) = W(i,j) - cb ;
     
            end
            W(i,:) = W(i,:)/omega(i);
            W(i,i) = -sum(W(i,:));
            
        end
        
    case 'levy'
        % conformal laplacian
        W = sparse(n,n);
        omega = compute_mesh_voronoi_area(vertex,face);
        ring = compute_vertex_face_ring(face);
       
        for i = 1:n
            
            if verb
                progressbar(i,n);
            end
               
            for b = ring{i}
                % b is a face adjacent to a
                bf = face(:,b);
                % compute complementary vertices
                if bf(1)==i
                    v = bf(2:3);
                elseif bf(2)==i
                    v = bf([1 3]);
                elseif bf(3)==i
                    v = bf(1:2);
                else
                    error('Problem in face ring.');
                end
                j = v(1); k = v(2);
                vi = vertex(:,i);
                vj = vertex(:,j);
                vk = vertex(:,k);
              
                % angles
                alpha = myangle(vi-vj,vk-vj);
                beta = myangle(vi-vk,vj-vk);
                
                % cotangents
                ca = 0.5*cotan( alpha ) ;
                cb = 0.5*cotan( beta ) ;
                
                % add weight
                aij = sqrt(omega(i)*omega(j)) ;
                aik = sqrt(omega(i)*omega(k)) ;

                W(i,k) = W(i,k) - ca/aik;
                W(i,j) = W(i,j) - cb/aij;
                
            end
            
            W(i,i) = -sum(W(i,:));
            
        end
        
    otherwise
        error('Unknown type.')
end

if ( isfield(options, 'normalize') && options.normalize==1 )
    W = diag(sum(W,2).^(-1)) * W;
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cotg = cotan(ang)

 EPS = 1e-5;
 
 if ( abs( abs(ang) - pi/2 ) < EPS )
    cotg = sign(ang)*EPS;
  else
    cotg = cot(ang);
 end
                            

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function theta = myangle(u,v)

du = norm(u) ;
dv = norm(v) ;
du = max(du,eps); dv = max(dv,eps);
theta = acos( (u'*v) / (du*dv) );



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function W = my_euclidean_distance(A,vertex)

if size(vertex,1)<size(vertex,2)
    vertex = vertex';
end

[i,j,s] = find(sparse(A));
d = norm( vertex(i,:) - vertex(j,:) );
W = sparse(i,j,d);
