classdef BoundingBox
% BoundingBox: bounding box class
%
% Author: Lucas Pagliosa and Paulo Pagliosa
% Last revision: 06/06/2017
%
% Description
% ===========
% An object of the class BoundingBox represents a 3D axis-aligned
% bounding box (AABB). The class defines methods to compute AABB properties
% such as center, volume, area, and size. Also, there are methods to
% draw and inflate to "swallow" a point.

%% Public read-only properties
properties (SetAccess = protected)
  p1;
  p2;
end

%% Public methods
methods
  % Constructor
  function this = BoundingBox(p1, p2)
    if nargin == 0
      this.setEmpty;
      return;
    end
    narginchk(1, 2);
    if nargin == 2
      this.p1 = min(p1, p2);
      this.p2 = max(p1, p2);
    elseif ~isa(p1, 'graphics.BoundingBox')
      error('bad arguments in BoundingBox ctor');
    else
      this.p1 = p1.p1;
      this.p2 = p1.p2;
    end
  end

  % Set empty
  function setEmpty(this)
    this.p1 = [+inf, +inf, +inf];
    this.p2 = [-inf, -inf, -inf];
  end

  % Compute center
  function c = center(this)
    c = (this.p1 + this.p2) * 0.5;
  end

  % Compute diagonal length
  function d = diagonalLength(this)
    d = this.p2 - this.p1;
    d = sqrt(d * d');
  end

  % Compute size
  function s = size(this)
    s = this.p2 - this.p1;
  end

  % Compute area
  function a = area(this)
    a = this.size;
    a = a(1) * (a(2) + a(3)) + a(2) * a(3);
    a = a + a;
  end

  % Compute volume
  function v = volume(this)
    v = prod(this.size);
  end

  % Is empty
  function b = isEmpty(this)
    b = any((this.p2 - this.p1) < 0);
  end

  % Draw
  function [h, v, f] = draw(this, axes, color, alpha)
    if nargin < 4
      alpha = 0.5;
    end
    if nargin < 3
      color = [0.8, 0.8, 0.8];
    end
    [v, f] = graphics.make_box(this.p1, this.p2);
    h = patch('Parent', axes, ...
      'Vertices', v, ...
      'Faces', f, ...
      'FaceColor', color, ...
      'FaceAlpha', alpha);
  end

  % Inflate
  function inflate(this, p)
    if isa(p, 'graphics.BoundingBox')
      this.p1 = min(this.p1, p.p1);
      this.p2 = max(this.p2, p.p2);
    elseif isscalar(p) && p > 0
      c = this.center + (1 - p);
      this.p1 = this.p1 * p + c;
      this.p2 = this.p2 * p + c;
    elseif size(p, 1) > 1
      inflateAABB(this, min(p));
      inflateAABB(this, max(p));
    else
      inflateAABB(this, p);
    end
  end
end

%% Private methods
methods (Access = private)
  % Inflate AABB
  function inflateAABB(this, p)
    this.p1 = min(this.p1, p);
    this.p2 = max(this.p2, p);
  end
end

end % BoundingBox
