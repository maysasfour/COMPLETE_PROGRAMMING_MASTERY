% example.m - Lesson 03: Variables and data types

% Everything in MATLAB is a matrix by default. A "scalar" is a 1x1 matrix.
x = 42;
fprintf('class(x) = %s, size = %s\n', class(x), mat2str(size(x)));

% Default numeric type is double (64-bit floating point), even for whole numbers
disp(class(5))       % double
disp(class(5.5))     % double
disp(class(int32(5))) % explicit integer type

% Other core types
s = 'single-quoted string';   % char array (row vector of chars)
d = "double-quoted string";   % string (MATLAB) / still usable in Octave as a string object
b = true;                     % logical
c = {1, 'two', [3 4 5]};      % cell array - can hold mixed types
st.name = 'Ada';              % struct - field access
st.age = 36;

disp(class(s))
disp(class(b))
disp(class(c))
disp(class(st))

% who/whos list variables in the workspace
whos x s b

% isa / class for type checks
fprintf('isa(x, ''double'') = %d\n', isa(x, 'double'));

% Dynamic typing: reassigning a variable can change its type
x = 'now a string';
disp(class(x))
