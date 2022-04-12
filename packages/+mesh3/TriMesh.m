classdef TriMesh < graphics.Renderable
% TriMesh: triangular mesh class
%
% Author: Paulo A. Pagliosa
% Last revision: 26/11/2021
%
% Description
% ===========
% An object of the class TriMesh represents a 3D triangular mesh.
%
% The class defines the public property NAME, the name of the mesh. The
% protected properties VERTICES and VERTEXNORMALS are nv x 3 matrices
% with the coordinates of the nv vertices and nv vertex normals of the
% mesh, respectively. The protected properties FACES and FACENORMALS are
% nf x 3 matrices with the connectivity of the nf (triangular) faces and
% the coordinates of the nf face normals of the mesh, respectively.
%
% The class declares public methods to:
%   - construct TriMesh instances (constructor);
%   - get vertices, faces, and normals;
%   - clone the mesh;
%   - set new vertices;
%   - compute laplacians, graph distances, and AABB;
%   - find nearest vertex to a point, and vertex neighbors;
%   - render the mesh;
%   - find ray/mesh intersections;
%   - transform the vertices of the mesh.
%
% The class also declares static methods that can be used for instancing a
% mesh from files (the supported formats are PLY and OFF).
%
% Example
% =======
% The following commands create a new mesh from file named 'bunny2k.ply'
% and show it in a TRI_MESH_VIEW:
%
% mesh = TriMesh.readPLY('bunny2k.ply');
% tri_mesh_view(0, mesh);
%
% See also
% ========
% TRI_MESH_VIEW

%% Public properties
properties
  name;
end

%% Public read, protected write properties
properties (SetAccess = protected)
  vertices;
  faces;
  faceNormals;
  vertexNormals;
end

%% Public methods
methods
  % Constructs an instance of this class.
  function this = TriMesh(vertices, faces, name)
    if nargin == 0
      return;
    end
    narginchk(2, 3);
    if size(vertices, 2) ~= 3 || size(faces, 2) ~= 3
      error('vertices and faces must have outer dimension equal to 3');
    end
    if nargin == 3
      this.name = name;
    else
      this.name = '';
    end
    this.vertices = vertices;
    this.faces = faces;
  end

  % Clones this mesh.
  function mesh = clone(this, vertices)
    mesh = mesh3.TriMesh;
    mesh.name = this.name;
    mesh.vertices = this.vertices;
    mesh.faces = this.faces;
    if nargin == 2
      mesh.setVertices(vertices);
    end
  end

  % Sets the vertices of this mesh.
  function setVertices(this, vertices)
    if size(vertices) ~= size(this.vertices)
      error('vertex dimensions must agree');
    end
    this.vertices = vertices;
    this.faceNormals = [];
    this.vertexNormals = [];
  end

  % Gets the number of vertices of this mesh.
  function n = numberOfVertices(this)
    n = size(this.vertices, 1);
  end

  % Gets vertices of this mesh.
  function v = vertex(this, i)
    v = this.vertices(i, :);
  end

  % Gets vertex normals of this mesh.
  function N = vertexNormal(this, i)
    this.makeVertexNormals;
    N = this.vertexNormals(i, :);
  end

  % Gets the number of faces of this mesh.
  function n = numberOfFaces(this)
    n = size(this.faces, 1);
  end

  % Gets faces of this mesh.
  function f = face(this, i)
    f = this.faces(i, :);
  end

  % Gets face normals of this mesh.
  function N = faceNormal(this, i)
    this.makeFaceNormals;
    N = this.faceNormals(i, :);
  end

  % Computes the AABB corners of this mesh.
  function [p1, p2] = computeAABB(this)
    p1 = min(this.vertices);
    p2 = max(this.vertices);
  end

  % Computes a Laplacian of this mesh.
  function L = computeLaplacian(this, type)
    if nargin == 1
      type = 'lb';
    end
    switch lower(type)
      case 'tutte'
        laplacian = @mesh3.compute_Tutte_Laplacian;
      case { 'lb', 'laplace-beltrami' }
        laplacian = @mesh3.compute_mesh_LB;
      otherwise
        error('Unknown Laplacian type');
    end
    L = laplacian(this.vertices, this.faces);
  end

  % Finds the nearest vertex of a point.
  function c = findNearestVertex(this, p)
    c = points.find_nearest_point(p, this.vertices);
  end

  % Finds the vertex neighbors within a radius.
  function [nid, d] = findVertexNeighbors(this, i, radius)
    [nid, d] = points.find_point_neighbors(this.vertex(i), ...
      this.vertices, ...
      radius);
  end

  % Finds the vertex k-ring of all vertices.
  function ring = findVertexRing(this, k)
    ring = mesh3.find_vertex_ring(this.vertices, this.faces, k);
  end

  % Computes the graph distances between all vertices.
  function A = computeGraphDistances(this, dtype, maxd)
    if nargin < 2
      dtype = 'geodesic';
    end
    if nargin < 3
      maxd = inf;
    end
    A = mesh3.compute_mesh_distances(this.vertices, ...
      this.faces, ...
      dtype, ...
      maxd);
  end

  % Renders this mesh,
  function h = render(this, axes)
    h = graphics.render_mesh(axes, this.faces, this.vertices);
    axis(axes, 'fill', 'equal', 'off');
  end

  % Finds the ray/mesh intersections.
  function [hit, info] = intersect(this, ray, all)
    if nargin < 3
      all = false;
    end
    this.makeFaceNormals;
    [hit, info] = mesh3.find_ray_mesh_intersections(this.vertices, ...
      this.faces, ...
      this.faceNormals, ...
      ray, ...
      all);
  end

  % Finds the nearest vertex to a mesh/ray intersection.
  function [index, p] = intersectVertex(this, ray)
    [hit, info] = this.intersect(ray);
    if ~hit
      index = -1;
      p = [];
      return;
    end
    t = this.face(info.triangle);
    v = this.vertex(t);
    d = v - repmat(info.p, 3, 1);
    [~, index] = min(sum(d .* d, 2));
    p = v(index, :);
    index = t(index);
  end

  % Finds the face from a mesh/ray intersection.
  function [index, p] = intersectFace(this, ray)
    [hit, info] = this.intersect(ray);
    if ~hit
      index = -1;
      p = [];
      return;
    end
    index = info.triangle;
    p = info.p;
  end

  % Transforms a given vertex of this mesh.
  function v = transformVertex(this, i, M)
    if isa(M, 'Transform3')
      v = M.transform(this.vertex(i));
    else
      v = points.transform_points(this.vertex(i), M);
    end
  end

  % Transforms all vertices of this mesh.
  function transform(this, M)
    this.vertices = this.transformVertex(:, M);
  end
end

%% Private methods
methods (Access = private)
  % Makes the face normals.
  function makeFaceNormals(this)
    if isempty(this.faceNormals)
      this.faceNormals = mesh3.compute_face_normals(this.vertices, ...
        this.faces);
    end
  end

  % Makes the vertex normals.
  function makeVertexNormals(this)
    if isempty(this.vertexNormals)
      this.makeFaceNormals;
      N = zeros(this.numberOfVertices, 3);
      for i = 1 : this.numberOfFaces
        f = this.faces(i, :);
        for j = 1 : 3
          N(f(j), :) = N(f(j), :) + this.faceNormals(i, :);
        end
      end
      d = sqrt(sum(N .^ 2, 2));
      d(d < eps) = 1;
      this.vertexNormals = N ./ repmat(d, 1, 3);
    end
  end
end

%% Public static methods
methods (Static)
  % Reads a file in PLY format.
  function mesh = readPLY(file)
    [v, f] = read_ply(file);
    mesh = mesh3.TriMesh(v, int32(f), file);
  end

  % Reads a file in OFF format.
  function mesh = readOFF(file)
    [v, f] = read_off(file);
    mesh = mesh3.TriMesh(v', int32(f'), file);
  end

  % Reads a file in OBJ format.
  function mesh = readOBJ(file)
    [v, f] = read_obj(file);
    mesh = mesh3.TriMesh(v', int32(f'), file);
  end
end

end % TriMesh
