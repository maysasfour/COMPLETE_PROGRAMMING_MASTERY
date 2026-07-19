% example.m - Lesson 04: Operators, including the critical element-wise vs matrix distinction

% Arithmetic
disp(7 + 3)   % 10
disp(7 - 3)   % 4
disp(7 * 3)   % 21
disp(7 / 3)   % 2.3333
disp(mod(7, 3)) % 1  - remainder, use mod() not %
disp(7 ^ 2)   % 49

% Matrix vs element-wise operators - THE core MATLAB distinction
A = [1 2; 3 4];
B = [5 6; 7 8];

disp('A * B (matrix multiplication):')
disp(A * B)

disp('A .* B (element-wise multiplication):')
disp(A .* B)

disp('A / B (matrix right division, A*inv(B)):')
disp(A / B)

disp('A ./ B (element-wise division):')
disp(A ./ B)

disp('A ^ 2 (matrix power, A*A):')
disp(A ^ 2)

disp('A .^ 2 (element-wise square):')
disp(A .^ 2)

% Comparison operators return LOGICAL ARRAYS when applied to arrays
v = [1 2 3 4 5];
disp(v > 3)          % 0 0 0 1 1

% Logical operators: & and | are element-wise; && and || short-circuit on scalars only
disp([1 0 1] & [1 1 0])
t = (5 > 3) && (2 < 4);
disp(t)

% Transpose
disp(A')
