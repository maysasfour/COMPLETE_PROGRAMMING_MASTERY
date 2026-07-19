% example.m - Lesson 07: Matrices and vectors (MATLAB's core data structure)

% Creation
row = [1 2 3 4 5];             % row vector
col = [1; 2; 3; 4; 5];         % column vector
A = [1 2 3; 4 5 6; 7 8 9];     % 3x3 matrix, ; separates rows
disp(row); disp(col'); disp(A)

% Ranges (colon operator): start:step:end - very MATLAB-idiomatic
r = 0:2:10;
disp(r)

% Built-in generators
disp(zeros(2,3))
disp(ones(2,2))
disp(eye(3))
disp(rand(1,1) >= 0 && rand(1,1) <= 1)  % rand() always in [0,1)

% Indexing is 1-BASED, not 0-based - the single most important MATLAB fact for newcomers
disp(row(1))     % first element (NOT row(0), which errors)
disp(row(end))   % last element
disp(A(2, 3))    % row 2, column 3
disp(A(2, :))    % entire row 2
disp(A(:, 1))    % entire column 1

% Logical/linear indexing
disp(row(row > 2))          % elements greater than 2
A(A > 5) = 0;                % assign via logical mask
disp(A)

% Concatenation
v1 = [1 2 3];
v2 = [4 5 6];
disp([v1 v2])       % horizontal concat
disp([v1; v2])       % vertical concat

% Reshaping and size
B = reshape(1:12, 3, 4);
disp(B)
fprintf('size(B) = %s, numel(B) = %d\n', mat2str(size(B)), numel(B));

% Common matrix functions
disp(sum(A))         % column sums
disp(sum(A, 2))       % row sums
disp(max(A(:)))        % max over the whole matrix (linearized)
disp(A')                % transpose

% Broadcasting: scalar-to-matrix and different-shaped vectors auto-expand
disp(A + 100)
disp([1;2;3] + [10 20 30])   % 3x1 + 1x3 -> broadcasts to 3x3
