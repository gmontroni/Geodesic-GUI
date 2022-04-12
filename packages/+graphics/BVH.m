classdef BVH < handle
% BVHNode: Bounding Volume Hierarchy class
%
% Author: Lucas C. Pagliosa
% Last revision: 04/10/2012
%
% Description
% ===========
% An object of the class BVH is a balanced tree structure. It contains
% nunNodes of nodes, each one represented as a Bounding Box. The class may 
% consult its nodes and can draw itself. The construct is finished if the 
% BHV reach its max level or a specified number of elements per node.

%% Private properties
properties (SetAccess = private)
  mesh;
  nodes;
  triangles;
  levels;
  numBins;
  maxLevels;
  maxElementsPerNode;
  centroids;
end

properties (GetAccess = private, SetAccess = private)
  cent;
  curSon;
end

%% Public methods
methods
  % Constructor
  function this = BVH(mesh, maxLevels, maxElementsPerNode)
    if nargin < 2 || maxLevels < 1
      this.maxLevels = 1;
    end
    if nargin < 3 || maxElementsPerNode < 1
      this.maxElementsPerNode = 20;
    end
    this.mesh = mesh;
    this.numBins = 4;
    build(this);
  end

  % Inflate
  function inflate(this, nid, point, triangle)
    if nargin < 4
      this.nodes(nid).inflate(point);
    else
      this.nodes(nid).inflate(point, this.mesh.vertex(triangle));
    end
  end

  % Intersect
  function [triangle, node, dist, point] = intersect(this, ray)
    tic;
    ray.invDir = 1 ./ ray.direction;
    ray.neg = ray.direction < 0;
    dist = inf;
    triangle = -1;
    node = -1;
    point = [];
    queue = Queue(30);
    queue.add(1);
    while ~queue.isEmpty()
      n = queue.remove();
      nd = this.nodes(n);
      [aabb_hit, ~] = nd.intersect(ray);
      if aabb_hit == false
        continue;
      end
      rc = nd.rc;
      if rc ~= -1
        queue.add([rc - 1, rc]);
      else
        nf = nd.numTri;
        indices = nd.indices(1:nf);
        N = this.mesh.faceNormal(indices);
        for i = 1:nf
          index = indices(i);
          v = this.mesh.vertex(this.mesh.face(index));
          [t_hit, d, p] = intersect_triangle(v, N(i, :), ray);
          if t_hit == true %&& d < dist
            dist = d;
            triangle = index;
            node = n;
            point = p(1, :);
          end
        end
      end
    end
  end  

  % Draw
  function draw(this, nid, color)
    if nid < 1 || nid > this.numNodes
      error('Invalid node index');
    end
    if nargin < 3
      color  = rand(1,3);
    end
    this.nodes(nid).draw(color, .2);
  end
  
  % Draw all
  function draw_all(this, color, trans)
    cameratoolbar;
    axis('equal', 'off');
    if nargin < 2
      color = [];
      trans = 1;
    end
    patch('Vertices', this.mesh.vertex(:), ...
          'Faces', this.mesh.face(:), ...
          'FaceColor', 'black', ...
          'FaceAlpha', trans);
    this.draw_BVH(1, color);
  end
  
  % Draw leaves
  function draw_leaves(this, nid, color)
    if nargin < 3
      nid = 1;
      color = [0,0,1];
    end
    [lc, rc] = this.nodes(nid).get_c();
    if rc == -1
      this.nodes(nid).draw(color, .2);
      return;
    end
    this.draw_leaves(lc, color);
    this.draw_leaves(rc, color);    
  end
  
  % Draw triangle and ray
  function draw_tar(this, ray, c, t)
    v = this.mesh.vertex(this.mesh.face(t));
    patch('Vertices', v, 'Faces', [1, 2, 3], 'FaceColor', 'r', 'FaceAlpha', .5);
    draw_ray(ray, c);
  end
end

%% Private methods
methods (Access = private)  
  % Draw BVH
  function draw_BVH(this, nid, color)
    if nargin < 3 || isempty(color)
      color =  rand(1,3);
      color1 = [];
      color2 = [];
    else
      color1 = color;
      color2 = color;      
    end
    this.nodes(nid).draw(color, .2);
    rc = this.nodes(nid).rc;
    if rc == -1
      return;
    end            
    this.draw_BVH(rc - 1, color1);
    this.draw_BVH(rc, color2);
  end
  
  % Get centroids
  function cent = get_cent(this, faceIndices, nf)
    cent(nf, :) = [0,0,0];
    for i = 1:nf;
      cent(i, :) = this.cent(faceIndices(i), :);
    end
  end
  
  % Init BVH
  function init(this)
    tic;
    faces = this.mesh.face(:);
    nf = size(faces, 1);
    if nf > 0
      this.nodes = BVHNode();
      for fid = 1:nf
        this.nodes(1).add(fid);
        this.inflate(1, 0, faces(fid, :));
      end
      build(this, 1);
    end
  end
  
  % Build BVH
  function build(this)
    tic;
    nf = this.mesh.numberOfFaces;
    if nf > 0
      this.triangles = 1 : nf;
      this.centroids = this.mesh.computeDualVertices;
      [p1, p2] = this.mesh.computeAABB;
      root = graphics.BVHNode(p1, p2);
      root.tRange = [1, nf];
      this.nodes = root;
      this.levels = 1;
      this.split(root);
    end
    fprintf('**BVH created in %f seconds\n', toc);
  end

  % Split BVH
  function split(this, node)
    nt = node.numberOfTriangles;
    if nt <= this.maxElementsPerNode || this.levels == this.maxLevels
      return;
    end
    cutPlan.cost = inf;
    size = node.size;
    [~, axis] = find(max(size) == size);
    binSize = size(axis) / this.numBins;
    p1 = node.p1;
    for bin = 1 : this.numBins - 1
      p1(axis) = p1(axis) + bin * binSize;
      lChild = BVHNode(p1, p1);
      rChild = BVHNode(p1, p1);
      for t = 1 : node.tRange(1) : node.tRange(2)
        centroid = this.centroids(t, :);
        triangle = this.mesh.vertex(this.mesh.face(t));        
        if less_then(centroid(axis), p1(axis))
          lChild.add(t);
          lChild.inflate(c, triangle);            
        else
          rChild.add(t);
          rChild.inflate(c, triangle);            
        end
      end
      currentCost = this.compute_sah(lChild, rChild);
      if currentCost < cutPlan.cost;
        cutPlan.cost = currentCost;
        cutPlan.laabb = lChild;
        cutPlan.raabb = rChild;
      end
    end % for bin = 1:this.numBins - 1
    this.nodes = [this.nodes, cutPlan.laabb, cutPlan.raabb];   
    this.numNodes = this.numNodes + 2;
    node.rc = this.curSon + 2;
    tmp = this.curSon;
    this.curSon = this.curSon + 2;
    node.indices = [];
    split(this, tmp + 1, level + 1);
    split(this, tmp + 2, level + 1);
  end
end

%% Private static methods
methods (Access = private, Static)
  % Compute SAH
  function cost = compute_sah(b1, b2)
    cost = b1.area * b1.numberOfTriagles + b2.area * b2.numberOfTriangles;
  end
end

end % BVH
