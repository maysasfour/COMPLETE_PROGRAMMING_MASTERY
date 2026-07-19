classdef Counter < handle
    % handle classes are REFERENCE types - mutating a method's obj mutates the
    % caller's object directly, unlike value classes (see Dog.m). This is the
    % MATLAB equivalent of "pass by reference" object semantics.
    properties
        count = 0
    end

    methods
        function increment(obj)
            obj.count = obj.count + 1;   % no need to return/reassign obj
        end
    end
end
