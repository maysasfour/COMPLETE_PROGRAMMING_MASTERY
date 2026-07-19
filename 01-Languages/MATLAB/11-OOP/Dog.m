classdef Dog < Animal
    % Inheritance via "< Animal". Overrides speak() (polymorphism).
    properties
        tricks = {}
    end

    methods
        function obj = Dog(name)
            obj = obj@Animal(name);   % call superclass constructor
            obj.sound = 'Woof';
        end

        function speak(obj)
            % Override: call the superclass method, then extend it
            speak@Animal(obj);
            fprintf('  (%s is a very good dog)\n', obj.name);
        end

        function obj = learnTrick(obj, trick)
            % MATLAB objects are VALUE types by default (handle classes are the
            % exception, see README) - mutating methods must return the updated
            % object and the caller must reassign it, exactly like a struct.
            obj.tricks{end+1} = trick;
        end
    end
end
