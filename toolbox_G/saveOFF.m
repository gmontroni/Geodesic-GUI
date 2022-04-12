function saveOFF( vertices, qfaces, tfaces, filename)
  file = fopen(filename,'w');
  
  fprintf(file, "OFF\n");
  fprintf(file, "#\n# %s\n#\n", filename);
  
  fprintf(file,"%d %d %d\n", size(vertices,1), size(qfaces,1)+size(tfaces,1), 0);
  
  for v = 1:size(vertices,1)
    fprintf(file, "%f %f %f\n", vertices(v,1), vertices(v,2), vertices(v,3));
  end
  
  for q = 1:size(qfaces,1)
    fprintf(file, "4 %d %d %d %d\n", qfaces(q,1)-1, qfaces(q,2)-1, qfaces(q,3)-1, qfaces(q,4)-1);
  end

  for t = 1:size(tfaces,1)
    fprintf(file, "3 %d %d %d\n", tfaces(t,1)-1, tfaces(t,2)-1, tfaces(t,3)-1);
  end
  
  
  
  fclose(file);
end