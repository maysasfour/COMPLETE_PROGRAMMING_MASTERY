classdef Point
  % A classdef file placed inside a +package folder is ALSO namespaced:
  % callers use geometry.Point(x,y), not just Point(x,y).
  properties
    x = 0
    y = 0
  endproperties
  methods
    function obj = Point(x, y)
      if nargin == 2
        obj.x = x;
        obj.y = y;
      endif
    endfunction
    function d = distance_to_origin(obj)
      d = sqrt(obj.x.^2 + obj.y.^2);
    endfunction
  endmethods
endclassdef
