function saveJSON( fullmesh, filename)
  file = fopen(filename,'w');
  
  json = jsonencode(fullmesh); 
  fprintf(file, json); 
    
  fclose(file);
end