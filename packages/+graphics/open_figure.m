function a = open_figure(title)
  f = figure;
  if nargin == 1
    f.Name = title;
  end
  f.MenuBar = 'none';
  a = gca;
  axis(a, 'square', 'equal', 'tight', 'vis3d');
  %cameratoolbar;
  %rotate3d on;
end
