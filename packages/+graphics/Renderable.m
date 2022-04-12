classdef Renderable < handle
% Renderable: generic renderable object class
%
% Author: Paulo A. Pagliosa
% Last revision: 05/09/2012
%
% Description
% ===========
% The abstract class Renderable encapsulates the behavior of generic
% renderable objects. It declares the abstract method RENDER(THIS, AXES),
% which is responsible for transforming the object data to a MATLAB
% graphical representation and plotting it into the AXES. The method
% have to be override in concrete classes derived from Renderable.

%% Public abstract methods
methods (Abstract)
  % Render
  h = render(this, axes) 
end

end % Renderable
