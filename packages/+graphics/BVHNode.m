classdef BVHNode < graphics.BoundingBox
% BVHNode: BVH node class
%
% Author: Lucas Pagliosa and Paulo Pagliosa
% Last revision: 06/06/2017
%
% Description
% ===========
% An object of the class BVHNode represents a node of a Bounding Volume
% Hierarchy (BVH). A BVH is a balanced tree structured, here as a vector. 
% A node of such structure is an AABB containing an index RCHILD that 
% indicates the position of the right child of the node in the tree.
% If RCHILD == 0, than the node is a leaf. The left child index is
% RCHILD - 1. The node can say if a ray intercepts it or not.

%% Public properties
properties
  rChild;
  tRange;
end

%% Public methods
methods
  % Constructores
  function this = BVHNode(p1, p2)
    if nargin == 0
      return;
    end
    this = this@graphics.BoundingBox(p1, p2);
    this.rChild = 0;
  end

  % Get number of triangles
  function n = numberOfTriangles(this)
    n = this.tRange(2) - this.tRange(1) + 1;
  end

  % Node/ray intersection
  function [hit, d] = intersect(this, r)
    d = -1;
    p = {this.p1, this.p2};
		tmin = (p{1 + r.neg(1)}(1) - r.origin(1)) * r.invDir(1);
		tmax = (p{2 - r.neg(1)}(1) - r.origin(1)) * r.invDir(1);
		amin = (p{1 + r.neg(2)}(2) - r.origin(2)) * r.invDir(2);
		amax = (p{2 - r.neg(2)}(2) - r.origin(2)) * r.invDir(2);
    if tmin > amax || amin > tmax
			hit = false;
      return;
    end
    if amin > tmin
			tmin = amin;
    end
    if amax < tmax
			tmax = amax;
    end
		amin = (p{1 + r.neg(3)}(3) - r.origin(3)) * r.invDir(3);
		amax = (p{2 - r.neg(3)}(3) - r.origin(3)) * r.invDir(3);
    if tmin > amax || amin > tmax
			hit = false;
      return;
    end
    if amin > tmin
			tmin = amin;
    end
    if amax < tmax
			tmax = amax;
    end
    if tmin > 0
      d = tmin;
    elseif tmax > 0
			d = tmax;
		else
			hit = false;
      return;
    end
		hit = true;
  end
end

end % BVHNode
