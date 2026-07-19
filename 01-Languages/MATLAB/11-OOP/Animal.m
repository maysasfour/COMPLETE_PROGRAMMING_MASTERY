classdef Animal
    % Base class. MATLAB requires classdef files to live one-class-per-file,
    % filename matching the class name exactly (same rule as plain functions).
    properties
        name
        sound = '...'   % default property value
    end

    methods
        function obj = Animal(name)
            % Constructor: same name as the class
            if nargin > 0
                obj.name = name;
            end
        end

        function speak(obj)
            fprintf('%s says %s\n', obj.name, obj.sound);
        end

        function s = describe(obj)
            s = sprintf('%s the %s', obj.name, class(obj));
        end
    end
end
