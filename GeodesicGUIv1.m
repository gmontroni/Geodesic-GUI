% INPUT:
%   filename: OBJ arquive from keenan's output
% OUTPUT:
%   mesh.json with all calculated information (dense mesh, base mesh, paths geodesic ...)
%   Off arquive
clc;clear;
global geodesic_library; 
global faces vertices mesh distances npath pathgeodesic mgeo cgeo h edge2vertex edge2face hp coordgeo t index


%% "release" is faster and "debug" does additional checks
geodesic_library = 'geodesic_debug';

%% Add path of toolbox 
AddToolbox 

%% Geodesic GUI
npath = 0; pathgeodesic = []; mgeo = []; cgeo = []; hp = []; index = []; coordgeo = zeros(2,3); t = 0;
[filename, directory] = uigetfile({'*.obj'},'Pick a file');         %open the file

if filename == 0 
    fprintf('Could not identify the mesh. \n'); clear;
    return
end

obj = readObj([directory, filename]); vertices = obj.v; faces = obj.f.v;          % organize vertices and faces

% [sing] = singularities([directory, filename]);      % identifies the singularities in keenan's output
sing = [];
[ColorMap] = ColorMaps(faces,sing);                 % color map to sings and surface


[mesh, edge2vertex, edge2face] = geodesic_new_mesh(vertices,faces);         % initilize new mesh
algorithm = geodesic_new_algorithm(mesh, 'exact');                          % initialize new geodesic algorithm


[source_id, distances] = geodesic_distance_and_source(algorithm);           % find distances to all vertices of the mesh; in this example we have a single source, so source_id is always equal to 1

%geodesic_delete; 

%-----------------plotting------------------------

hold off
h_fig = figure(1);
h = trisurf(faces,vertices(:,1),vertices(:,2),vertices(:,3),distances, 'FaceColor', 'flat', 'EdgeColor', 'k');       %plot the mesh
daspect([1 1 1]);

set(h,'FaceColor','flat',...
       'FaceVertexCData',ColorMap,...
       'CDataMapping','scaled');                  % set colormap

set(h_fig,'KeyPressFcn',@keypress);               % starts key press function

h.ButtonDownFcn = @buttonDownCallback;            % starts geodesic function

%-----------------------COMMANDS------------------------

fprintf('|-------------------------------------------|\n')
fprintf('|COMMANDS GEODESIC GUI                      |\n')
fprintf('|-------------------------------------------|\n')
fprintf('|left-click: source point geodesic.         |\n')
fprintf('|right-click: destination point geodesic.   |\n')
fprintf('|w: determine the base mesh.                |\n')
fprintf('|r: removes the last created geodesic path. |\n')
fprintf('|q: color the correct tri/quads faces.      |\n')
fprintf('|Q: discolor the correct tri/quads faces.   |\n')
fprintf('|d: deletes a specific geodesic path.       |\n')
fprintf('|s: save arquive json and off.              |\n')
fprintf('|f: hides the face.                         |\n')
fprintf('|F: shows the face.                         |\n')
fprintf('|e: hides the edge.                         |\n')
fprintf('|E: shows the edge.                         |\n')
fprintf('|-------------------------------------------|\n\n')


function buttonDownCallback(hObj, event)
    global algorithm vertices mesh distances pathg pathgeodesic npath mgeo cgeo hp coordinateSelected coordgeo t 
    % the left mouse button marks the starting point
    % while the right mouse button marks the end point of the geodesic path
    
    f = hObj.Parent.Parent;
    f.SelectionType;
    if strcmp(f.SelectionType, 'normal')           % left click
        %  FIND NEAREST (X,Y,Z) COORDINATE TO MOUSE CLICK
        % Inputs:
        %  hObj (unused) the axes
        %  event: info about mouse click
        % OUTPUT
        %  coordinateSelected: the (x,y,z) coordinate you selected
        %  minIDx: The index of your inputs that match coordinateSelected. 

        x = hObj.XData; 
        y = hObj.YData; 
        z = hObj.ZData; 

        pt = event.IntersectionPoint;       % The (x0,y0,z0) coordinate you just selected
        coordinates = [x(:),y(:),z(:)];     % matrix of your input coordinates
        dist = pdist2(pt,coordinates);      % distance between your selection and all points
        [~, minIdx] = min(dist);            % index of minimum distance to points
        
        coordinateSelected = coordinates(minIdx,:);       % the selected coordinate
        
        if (-1)^t == 1
            coordgeo(1,:) = coordinateSelected;
            t = t+1;
        else
            coordgeo(2,:) = coordinateSelected;
            t = t+1;
        end
        
        % from here you can do anything you want with the output.  This demo
        % just displays it in the command window.  
        fprintf('[x,y,z] = [%.5f, %.5f, %.5f]\n', coordinateSelected)

        algorithm = geodesic_new_algorithm(mesh, 'exact');      % initialize new geodesic algorithm
        
        % identify the vertex id of surface
        [m,~] = size(vertices);
        coordinatess = ones(m,3).*coordinateSelected;
        C = vertices == coordinatess;
        [vertex_id, ~] = find(C== true);
        vertex_id = vertex_id(1);
        
        % geodesic source points
        source_points = {geodesic_create_surface_point('vertex',vertex_id,coordinateSelected)};
        geodesic_propagate(algorithm, source_points);

        %-----------------plotting------------------------
        hold on
        plot3(source_points{1}.x, source_points{1}.y, source_points{1}.z, 'og', 'MarkerSize',3);    % plot sources

    end


    g = hObj.Parent.Parent;
    g.SelectionType;
    if strcmp(g.SelectionType, 'alt')            %right click

        x = hObj.XData; 
        y = hObj.YData; 
        z = hObj.ZData; 

        pt = event.IntersectionPoint;       % The (x0,y0,z0) coordinate you just selected
        coordinates = [x(:),y(:),z(:)];     % matrix of your input coordinates
        dist = pdist2(pt,coordinates);      % distance between your selection and all points
        [~, minIdx] = min(dist);            % index of minimum distance to points

        coordinateSelected = coordinates(minIdx,:);       % the selected coordinate

        % from here you can do anything you want with the output.  This demo
        % just displays it in the command window.  
        fprintf('[x,y,z] = [%.5f, %.5f, %.5f]\n', coordinateSelected)

        % identify the vertex id of surface
        [m,~] = size(vertices);
        coordinatess = ones(m,3).*coordinateSelected;
        C = vertices == coordinatess;
        [vertex_id, ~] = find(C== true);
        vertex_id = vertex_id(1);
       
        % geodesic destination points
        destination = geodesic_create_surface_point('vertex',vertex_id,coordinateSelected);
        pathg = geodesic_trace_back(algorithm, destination);          % find a shortest path from source to destination
        
        npath = npath + 1;
        pathgeodesic(npath).geodesic = pathg;
        mgeo(npath,:) = [pathg{1}.id pathg{end}.id];
        cgeo(npath,:) = [pathg{1}.x pathg{1}.y pathg{1}.z pathg{end}.x pathg{end}.y pathg{end}.z];
        % coorgeo(npath,:) = [pathg{1}.x ]

        [~, distances] = geodesic_distance_and_source(algorithm);     % find distances to all vertices of the mesh; in this example we have a single source, so source_id is always equal to 1
        
        %-----------------plotting------------------------
        hold on
        plot3(destination.x, destination.y, destination.z, 'oy', 'MarkerSize',3);       % plot destination 
        [x,y,z] = extract_coordinates_from_path(pathg);                                 % prepare path data for plotting
        hp(npath) = plot3(x*1.001,y*1.001,z*1.001,'Color',[0.6350 0.0780 0.1840],'LineWidth',2);    % plot path

    end

end

function keypress(~,event)
    global vertices faces pathgeodesic mgeo cgeo edge2vertex h npath edge2face return_mgeo return_pathgeodesic fullmesh hp edges index ht coordgeo
    
    %  BUTTOM KEY PRESS
        % Inputs:
        %  hObj (unused) the axes
        %  event: Key Press
        % OUTPUT
        %  buttons with actions

    hold on
    axes = h.Parent;
    switch event.Character %event.Key does not recognize upper letters
                           %use event.Character for this
        case 'w'           %determine the base mesh
            
            fullmesh = create_fullmesh(vertices, faces, pathgeodesic, mgeo, edge2vertex, edge2face );
            patch('Faces',fullmesh.base_mesh.quads,'Vertices',fullmesh.base_mesh.coords,'FaceColor','c');
            patch('Faces',fullmesh.base_mesh.triangles,'Vertices',fullmesh.base_mesh.coords,'FaceColor','c');

        case 'r'        %removes the last created geodesic path
            
            npath = npath - 1;
            if size(mgeo,1) == 1
                geodesicdelet = hp(1,npath+1);
                delete(geodesicdelet)  %delete the last geodesic
                return_mgeo = [];
                cgeo = [];
                return_pathgeodesic = [];
                hp = [];
                
            elseif size(hp,2) == 0
                disp('all geodesics have been removed')
            else
                geodesicdelet = hp(1,npath+1);
                delete(geodesicdelet)  %delete the last geodesic
                return_mgeo = mgeo(1:npath,:);
                cgeo(npath+1,:) = [];
                return_pathgeodesic = pathgeodesic(:,1:npath);
            end
            
            mgeo = return_mgeo;
            pathgeodesic = return_pathgeodesic;
        case 'q'        %check tri and quad mesh
            
            [edges] = define_fullmesh( vertices, faces, pathgeodesic, mgeo, edge2vertex, edge2face );

            if size(edges,1)>= 1
                [~,~,index1] = intersect(edges,mgeo,'rows');
                [~,~,index2] = intersect(edges,flip(mgeo,2),'rows');
                index = [index1 ;index2];
                for i=1:size(index,1)
                    [x,y,z] = extract_coordinates_from_path(pathgeodesic(index(i)).geodesic);
                    ht(i) = plot3(x*1.001,y*1.001,z*1.001,'Color','w','LineWidth',2);
                end
            else
                disp('')
            end
        case 'Q'        %check tri and quad mesh
           
            for i=1:size(index,1)
                delete(ht(i))
            end

        case 'd'
            
            if npath >= 1
                [~,~,index1] = intersect([coordgeo(2,:) coordgeo(1,:)],cgeo,'rows');
                [~,~,index2] = intersect([coordgeo(1,:) coordgeo(2,:)],cgeo,'rows');
                index = [index1 ;index2];
            end

            if(isempty(index))
                index = 0;
            end

            if index == 0
                disp('geodesic not found, try again.')
            else
                npath = npath - 1;
                geodesicdelet = hp(1,index);
                delete(geodesicdelet)  %delete the last geodesic
                mgeo(index,:) = [];
                cgeo(index,:) = [];
                pathgeodesic(index) = [];
            end

        case 's'        %save arquive json and off

            saveJSON(fullmesh, 'mesh.json');
            saveOFF(fullmesh.base_mesh.coords, fullmesh.base_mesh.quads, fullmesh.base_mesh.triangles, 'mesh.off');
        case 'f'        %hides the face

            set(h,'FaceAlpha',0)
        case 'F'        %shows the face

            set(h,'FaceAlpha',1)
        case 'e'        %hides the edge

            set(h,'EdgeAlpha',0)
        case 'E'        %shows the edge

            set(h,'EdgeAlpha',1)         
    end
end