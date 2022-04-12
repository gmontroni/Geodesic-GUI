classdef Transform3
% Transform3: 3D transformation class
%
% Author: Paulo A. Pagliosa
% Last revision: 15/05/2017
%
% Description
% ===========
% An object of the class Transform3 represents a 3D geometric
% transformation.

%% Public properties
properties
  M;
end

%% Public static methods
methods (Static)
  % Rotation of alpha rad around X axis
  function t = rotationX(alpha)
    cos_a = cos(alpha);
    sin_a = sin(alpha);
    t = graphics.Transform3;
    t.M = [1 0 0 0; 0 cos_a -sin_a 0; 0 sin_a cos_a 0; 0 0 0 1];
  end

  % Rotation of alpha rad around Y axis
  function t = rotationY(alpha)
    cos_a = cos(alpha);
    sin_a = sin(alpha);
    t = graphics.Transform3;
    t.M = [cos_a 0 sin_a 0; 0 1 0 0; -sin_a 0 cos_a 0; 0 0 0 1];
  end

  % Rotation of alpha rad around Z axis
  function t = rotationZ(alpha)
    cos_a = cos(alpha);
    sin_a = sin(alpha);
    t = graphics.Transform3;
    t.M = [cos_a -sin_a 0 0; sin_a cos_a 0 0; 0 0 1 0; 0 0 0 1];
  end

  % TODO: translation, scale, general rotation, etc.
end

%% Public methods
methods
  % Compose t1 with t2 (t1 * t2)
  function t = mtimes(t1, t2)
    t = graphics.Transform3;
    t.M = t1.M * t2.M;
  end

  % Transform point p
  function p = transform(this, p)
    np = size(p, 1);
    for i = 1 : np
      p(i, :) = this.M(1 : 3, 1 : 3) * p(i, :)' + this.M(1 : 3, 4);
    end
  end
end

end % Transform3
