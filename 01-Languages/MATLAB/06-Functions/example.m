% example.m - Lesson 06: Functions
% MATLAB's classic rule: one function per .m file, filename == function name.
% (Local/nested functions inside a script are a newer MATLAB feature with
% inconsistent support across Octave versions - see README for the portability note.)
% Run this from within this folder so Octave/MATLAB can find the sibling function files.

[s, p] = sum_and_product(4, 5);
fprintf('sum=%d product=%d\n', s, p);

disp(greet('Ada'))
disp(greet('Ada', 'Good morning'))

disp(add_all(1, 2, 3, 4, 5))

a = describe_call();
[a, b] = describe_call();

sq = @(x) x.^2;   % anonymous function handle - full coverage in Lesson 12
disp(sq(5))

disp(factorial_r(6))
