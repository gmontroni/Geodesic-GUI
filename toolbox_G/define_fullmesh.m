function [fullmesh] = define_fullmesh( vertices, faces, pathgeodesic, mgeo, edge2vertex, edge2face )

fullmesh.number_of_vertices = size(vertices,1);
fullmesh.number_of_triangles = size(faces,1);  
fullmesh.number_of_edges = size(edge2vertex,1);  
fullmesh.number_of_geodesics = size(pathgeodesic,2);  

fullmesh.coords = vertices;
fullmesh.triangles = faces;
fullmesh.paths = pathgeodesic;
fullmesh.paths_ends = mgeo;
fullmesh.edge_to_vertices = edge2vertex;
fullmesh.edge_to_triangles = edge2face;
fullmesh.vertices = struct([]);

assert( size(fullmesh.coords,2) == 3 );
assert( size(fullmesh.triangles,2) == 3 );
assert( min(min(fullmesh.triangles)) == 1 );
assert( max(max(fullmesh.triangles)) == fullmesh.number_of_vertices );
assert( fullmesh.number_of_geodesics == size(mgeo,1) );
assert( 2 == size(mgeo,2) );
assert( size(edge2vertex,1) == size(edge2face,1) );
assert( size(edge2vertex,2) == size(edge2face,2) );
assert( min(min(edge2vertex)) == 1 );
assert( max(max(edge2vertex)) == fullmesh.number_of_vertices );
assert( min(min(edge2face)) == 1 );
assert( max(max(edge2face)) == fullmesh.number_of_triangles );


fullmesh = create_vertices_stars(fullmesh);

fullmesh = define_orientation(fullmesh);

fullmesh = define_base_mesh( fullmesh );