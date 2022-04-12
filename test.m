clear; AddToolbox; load('geodesictest.mat');

allstars = create_allstars(vertices, faces);  %estrelas dos vertices orientadas

geodesics_oriented = define_orientation(vertices, allstars, pathgeodesic, mgeo, edge2vertex); %geodesicas dos vertices orientadas

[qvertices, qfaces, tfaces ] = create_quad_tri_mesh(vertices, mgeo, geodesics_oriented);

saveOFF( qvertices, qfaces, tfaces, 'base.off');