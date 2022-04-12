classdef TriMeshSpectrum < handle
% Triangle mesh spectrum class
% TODO: detailed explanation

%% Public read-only properties
properties (SetAccess = private)
  mesh;
  L; % Laplacian
end

%% Protected read/write properties
properties (GetAccess = protected, SetAccess = protected)
  spectrum; % eigenvectors and eigenvalues
end

%% Public methods
methods
  % Constructor
  %
  % Input arguments
  % mesh: triangule mesh with N vertices.
  % dim (optional): eigenspace dimension (less than N).
  function this = TriMeshSpectrum(mesh, dim)
    if nargin == 0
      return;
    end
    % Check input arguments
    narginchk(1, 2);
    if ~isa(mesh, 'mesh3.TriMesh')
      error('mesh must be an existing triangle mesh');
    end
    max_dim = mesh.numberOfVertices;
    if nargin == 1
      dim = max_dim;
    elseif dim < 1 || dim > max_dim
      error('dim must be an integer between 1 and %d', max_dim);
    end
    % Compute mesh Laplacian
    LB = mesh.computeLaplacian('lb');
    % Perform eigendecomposition of the Laplacian
    [V, D] = eigen.eigendecomposition(LB, dim);
    this.mesh = mesh;
    this.L = LB;
    this.spectrum = struct('V', V, 'D', D);
  end

  % Get dimension of the spectrum
  function n = dim(this)
    n = size(this.spectrum.V, 2);
  end

  % Get spectrum
  function [V, D] = get(this, i)
    V = this.spectrum.V(:, i);
    if nargout == 2
      D = this.spectrum.D(i);
    end
  end

  % Get eingenvalue
  function D = eigenvalue(this, i)
    D = this.spectrum.D(i);
  end

  % Get values of eigenfunction
  function x = values(this, i, j)
    x = this.spectrum.V(i, j);
  end

  % Get the first K coefficients of functions F
  function A = project(this, F, K)
    A = eigen.project_functions(this.spectrum.V, F, K);
  end

  % Project mesh geometry
  function A = projectGeometry(this, K)
    if nargin == 1
      K = this.dim;
    end
    A = this.project(this.mesh.vertex(:), K);
  end

  % Reconstruct functions from coefficients
  function F = reconstruct(this, A)
    F = eigen.reconstruct_functions(this.spectrum.V, A);
  end

  % Reconstruct mesh from geometry coefficients
  function mesh = reconstructMesh(this, A)
    mesh = this.mesh.clone(this.reconstruct(A));
  end
end

end % TriMeshSpectrum
