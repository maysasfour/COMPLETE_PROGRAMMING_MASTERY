% example.m - Lesson 02: Syntax basics

% Comments use % (or %{ ... %} for a block comment)
%{
This is a block comment.
Spans multiple lines.
%}

% Semicolon suppresses output; omitting it echoes the result as ans
x = 5        % no semicolon -> prints "x = 5"
y = 10;      % semicolon -> silent

% Line continuation uses ... at end of line
total = 1 + 2 + ...
        3 + 4;
disp(total)

% Multiple statements on one line, separated by comma (echoes) or semicolon (silent)
a = 1, b = 2;
disp([a b])

% Scripts vs functions: this file is a SCRIPT (no function keyword at top).
% Function files must start with "function" and the filename must match the function name.
