function omega = compute_mesh_voronoi_area(vertex,face)

[vertex,face] = check_face_vertex(vertex,face);

n = max(max(face));
omega = zeros(n,1);
ring = compute_vertex_face_ring(face);
        
for i = 1:n
    for b = ring{i}
        % b is a face adjacent to a
        bf = face(:,b);
        % compute complementary vertices
        if ( bf(1) == i ) 
            v = bf(2:3);
        elseif ( bf(2) == i )
            v = bf([1 3]);
        elseif ( bf(3) == i )
            v = bf(1:2);
        else
            error('Problem in face ring.');
        end
        
        j = v(1); k = v(2);
        vi = vertex(:,i);
        vj = vertex(:,j);
        vk = vertex(:,k);
                
        %add area of voronoi cell
        omega(i) = omega(i) + voronoi_area(vi,vj,vk); 
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function omega = voronoi_area(vi,vj,vk)

%BELKIN M., SUN J., WANG Y.: Discrete laplace operator on meshed surfaces.
omega = tri_area(vi,vj,vk)/3;

%mij = (vi+vj)/2;
%mik = (vi+vk)/2;
%inctr = incenter(vi,vj,vk);
%omega = tri_area(vi,mij,inctr) + tri_area(vi,mik,inctr);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function area = tri_area(A,B,C)

la = norm(B - C);
lb = norm(A - C);
lc = norm(A - B);

s = (la + lb + lc)/2;

area = sqrt( s*(s-la)*(s-lb)*(s-lc) );



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function inctr = incenter(A,B,C)

la = norm(B-C);
lb = norm(A-C);
lc = norm(A-B);

P = la + lb + lc;

X = la*A(1) + lb*B(1) + lc*C(1);
Y = la*A(2) + lb*B(2) + lc*C(2);
Z = la*A(3) + lb*B(3) + lc*C(3);

inctr = [X ; Y ; Z]/P;
