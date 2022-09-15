function [ColorMap] = ColorMaps(faces,sing)
% sets the color of the mesh and the singularities

% Input: 
%   faces: coordinates of the mesh faces
%   sing: singularity matrix

%Output: 
%   ColorMap: surface color map

%Guilherme V. Montroni

[m,n] = size(faces);
Color = [0.8588; 0.6118; 0.1451];          % initial color surface (orange)
ColorMap = (ones(n,m).*Color)';
RedColor = [1,0,0]; BlueColor = [0,0,1];   % singularities collors

% sing kx2, where k is the number of singularities
% the second column defines whether the singularity is positive or negative
[k,~] = size(sing);

if k ~= 0
    for i=1:k
        if sing(i,2) >= 0      % positive case, sing red
            ColorMap(sing(i,1),:) = RedColor;
        else                   % negative case, sing blue 
            ColorMap(sing(i,1),:) = BlueColor;
        end
    end
end
end