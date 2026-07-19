% example.m - Lesson 08: Strings (char arrays vs. string objects)

% char array: a row vector of characters - the "classic" MATLAB string
c = 'hello';
disp(class(c))
disp(c(1))          % 1-based indexing works on chars too
disp(size(c))        % 1x5 - it really is a 1-D array

% MATLAB (R2016b+) has a distinct scalar "string" TYPE created with double quotes,
% with its own class(s) == "string" and array-of-strings semantics, separate from char.
% GNU Octave 9.2 (verified here) treats "double-quoted" text as PLAIN CHAR, identical
% to 'single-quoted' - class(s) below prints "char", not "string". Octave does not
% implement MATLAB's string() function/type at all (confirmed: calling string(c) below
% throws "'string' undefined ... not yet implemented in Octave"). This is one of the
% few genuine MATLAB/Octave incompatibilities - see this lesson's README for the full
% disclosure. The workaround used throughout this course is to stick to char arrays
% and cell arrays of char, which behave identically in both.
s = "hello";
disp(class(s))   % "char" in Octave 9.2; would be "string" in real MATLAB

% Concatenation
disp(['hello' ' ' 'world'])              % char concat via []
disp(strcat('hello', 'world'))            % strcat trims trailing whitespace on char inputs
fprintf('%s %s\n', 'hello', 'world');       % printf-style

% Common string functions
name = 'Ada Lovelace';
disp(upper(name))
disp(lower(name))
disp(length(name))
disp(strsplit(name, ' '))
disp(strrep(name, 'Ada', 'Grace'))
disp(strtrim('   padded   '))
disp(fliplr(name))                 % reverse a char array

% Numeric <-> string conversion
disp(num2str(3.14159, 4))    % 4 significant digits
disp(str2num('42') + 1)       % NOTE: str2num evaluates as an expression (security caveat in README)
disp(str2double('3.14'))       % str2double is the safe numeric-only parser

% sprintf for formatted strings (like fprintf but returns a string instead of printing)
msg = sprintf('%s is %d years old', 'Ada', 36);
disp(msg)

% Comparison
disp(strcmp('abc', 'abc'))     % 1 - exact match required (unlike == which compares char-by-char)
disp('abc' == 'abc')             % element-wise char comparison -> logical array
disp(strcmpi('ABC', 'abc'))       % case-insensitive
