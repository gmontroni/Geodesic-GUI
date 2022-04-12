faces = [ 1 2 3; 1 4 5; 1 3 4; 6 9 12; 2 8 11; 6 1 5; 7 8 1; 6 7 1; 3 2 10; 2 1 8; 6 5 9; 10 2 11 ];
indices = [1:size(faces,1)];
faces = [faces indices'];
for v = 1:2
   f1 = faces(faces(:,1)==v,:);
   f2 = faces(faces(:,2)==v,[2 3 1 4]);
   f3 = faces(faces(:,3)==v,[3 1 2 4]);
   f = [f1;f2;f3];
   star = f(1,:);
   for i = 1:size(f,1)-1
      star = [ star; f(f(:,2)==star(i,3),:)];
   end
   allstars(v).v = v;
   allstars(v).star = star;
   allstars(v)
end