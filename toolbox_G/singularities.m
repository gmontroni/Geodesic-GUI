function [sing] = singularities(filename)
% determines the singularities according to the output of Keenan's algorithm.

% Input: 
%   filename: text file (tested to txt,obj)
    
% Output: 
%   sing: kx2 singularity matrix, where k is the number of singularities

%Guilherme V. Montroni
sing =[];
file = fopen(filename,'r');      % open the file

% skip the first 34 lines (Keenan's introduction)
for i = 1:33
    line = regexp(fgetl(file), '\s', 'split');  % each word of the text line is a column of the matrix
end                                             
                                                
i = 1; j = 1; cond = true;    

while cond
L = fgetl(file);                         % read the line

    if ~ischar(L); break; end            % condition to terminate the process (no char found)

line = regexp(L, '\s', 'split');         % row elements divided into words (columns)

% look at Keenan's obj to understand
    if strcmpi(line{2}, 'singularity')     % if the second element of the line is the word
                                           % singularity then the id is saved
        sing(i,1) = str2double(line{3});   % of the face and the value.
        sing(i,2) = str2double(line{4});   
        i = i+1;
    end
end

fclose(file);
end