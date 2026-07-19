function msg = greet(name, salutation)
    % nargin lets a function detect how many inputs were actually supplied,
    % enabling optional/default arguments without any special syntax.
    if nargin < 2
        salutation = 'Hello';
    end
    msg = sprintf('%s, %s!', salutation, name);
end
