function fullmesh = define_orientation( fullmesh )
%Orienta as geodesicas a partir dos vértices do triangulo

geodesics_indices = 1:size(fullmesh.paths,2);
geodesics_id = [fullmesh.paths_ends geodesics_indices'];

for vertex = 1:fullmesh.number_of_vertices % poderia alterar para percorrer apenas o conjunto de inicio/fim de geodesicas
    group1 = geodesics_id(geodesics_id(:,1)==vertex,:);   %ponto inicial da geodesica
    group2 = geodesics_id(geodesics_id(:,2)==vertex,:);   %ponto final
    geodesics_of_vertex = [group1;group2];
    star = fullmesh.vertices(vertex).star;
    number_of_geodesics = size(geodesics_of_vertex,1);
    geodesics_oriented = zeros(number_of_geodesics,1);
    if number_of_geodesics > 0
        gcells = zeros(number_of_geodesics,2);
        for geo = 1:number_of_geodesics            %percorre as geodesicas
            geodesic_id = geodesics_of_vertex(geo,3);
            if geodesics_of_vertex(geo,1)==vertex    %
                second = 2;
            else
                assert(geodesics_of_vertex(geo,2)==vertex,'Impossible!');
                second = size(fullmesh.paths(geodesic_id).geodesic,1)-1;
            end
            edge_or_vertex = fullmesh.paths(geodesic_id).geodesic{second}.id;
            if strcmp(fullmesh.paths(geodesic_id).geodesic{second}.type,'vertex')
                triangle = star(star(:,2)==edge_or_vertex, 4);
                triangle_order = 0;
            else
                assert(strcmp(fullmesh.paths(geodesic_id).geodesic{second}.type,'edge'), 'Is it not only vertex or edge types?'); %vai que não e edge
                t1a = star(star(:,2)==fullmesh.edge_to_vertices(edge_or_vertex,1), 4);
                t1b = star(star(:,3)==fullmesh.edge_to_vertices(edge_or_vertex,1), 4);
                t2a = star(star(:,2)==fullmesh.edge_to_vertices(edge_or_vertex,2), 4);
                t2b = star(star(:,3)==fullmesh.edge_to_vertices(edge_or_vertex,2), 4);
                triangle = intersect([t1a t1b],[t2a t2b]);
                assert(size(triangle,1)==1,'A geodesic in more than one triangle!');         %tem que ter apenas um triangulo
                p1 = star(star(:,4)==triangle, 2);   %id dos vertices
                p2 = star(star(:,4)==triangle, 3);
                middle = [fullmesh.paths(geodesic_id).geodesic{second}.x; %coordenada onde a geodesica cruza a aresta
                    fullmesh.paths(geodesic_id).geodesic{second}.y;
                    fullmesh.paths(geodesic_id).geodesic{second}.z ];
                triangle_order = norm(fullmesh.coords(p1) - fullmesh.coords(p2)) / norm(fullmesh.coords(p1) - middle);  %proporção
            end
            gcells(geo,:) = [ triangle geodesic_id ];
        end
        
        number_of_triangles = size(star,1);
        assert(number_of_triangles > 2);
        geo = 1;
        for tri = 1:number_of_triangles
            triangle = star(tri,4);
            geodesics = gcells( gcells(:,1)==triangle,: );
            if size(geodesics, 1) == 1
                assert(geo <= number_of_geodesics, 'Is there more geodesics now?' );
                geodesics_oriented(geo) = geodesics(1,2);
                geo = geo + 1;
            elseif size(geodesics,1) > 1   %mais de uma geodesica no triangulo
                assert(false);
            end
        end
    end
    fullmesh.vertices(vertex).paths_oriented = geodesics_oriented;
end

end