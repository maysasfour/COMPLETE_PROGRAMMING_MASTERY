% example.m - Lesson 12: Functional concepts (anonymous functions & function handles)

% Anonymous function - @(args) expression, always a single expression (no statements/blocks)
square = @(x) x.^2;
disp(square(5))

% Closures: anonymous functions capture variables BY VALUE at creation time
base = 10;
addBase = @(x) x + base;
disp(addBase(5))     % 15
base = 1000;           % changing base afterward does NOT affect addBase - it already captured 10
disp(addBase(5))     % still 15

% Function handles to named functions (@funcname)
fh = @sin;
disp(fh(0))
disp(func2str(square))     % introspect an anonymous function's source text

% Passing functions as arguments (higher-order functions)
function result = apply_twice(f, x)
    result = f(f(x));
end
disp(apply_twice(@(x) x + 3, 10))   % (10+3)+3 = 16

% arrayfun - apply a function element-wise over an array (MATLAB's "map")
v = 1:5;
disp(arrayfun(@(x) x^2, v))

% cellfun - the same idea for cell arrays (e.g. of strings)
names = {'ada', 'grace', 'linus'};
disp(cellfun(@upper, names, 'UniformOutput', false))
disp(cellfun(@length, names))     % UniformOutput true (default) when results are scalars

% Reduction-style patterns: MATLAB has no built-in reduce, but sum/prod/arrayfun cover most cases
disp(sum(arrayfun(@(x) x^2, 1:5)))   % sum of squares 1..5

% Filtering: logical indexing IS the idiomatic "filter" in MATLAB
disp(v(arrayfun(@(x) mod(x,2)==0, v)))   % even numbers - usually just v(mod(v,2)==0) directly
disp(v(mod(v,2)==0))                       % the more idiomatic vectorized version
