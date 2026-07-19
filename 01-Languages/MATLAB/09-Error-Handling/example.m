% example.m - Lesson 09: Error handling with try/catch

% Basic try/catch - err is an MException object
try
    x = [1 2 3];
    y = x(10);   % out-of-bounds index -> error
catch err
    fprintf('Caught error: %s\n', err.message);
    fprintf('Identifier: %s\n', err.identifier);
end

% Throwing your own errors with error() - printf-style formatting built in
% (check_positive.m is a sibling function file - see Lesson 06 for why)
try
    check_positive(5);
    check_positive(-3);
catch err
    fprintf('Caught: %s (id=%s)\n', err.message, err.identifier);
end

% MException(id, fmt, ...) as an explicit constructor + throw() is standard MATLAB
% for building an error object before raising it. CONFIRMED INCOMPATIBILITY: GNU
% Octave 9.2 does not implement the MException() constructor at all ("not yet
% implemented in Octave" - verified by running this exact call). The err object
% CAUGHT by a catch block works fine and identically in both (see above/below) -
% only the explicit MException(...) constructor call is the actual gap. Octave's
% own error()/lasterror() combination is the portable substitute; see README.
try
    error('MyApp:customError', 'Something went wrong with value %d', 42);
catch err
    fprintf('Custom: %s (id=%s)\n', err.message, err.identifier);
end

% assert() - shorthand for "throw an error if condition is false"
try
    assert(1 == 2, 'One is definitely not two');
catch err
    fprintf('Assert failed: %s\n', err.message);
end

% Nested try/catch and rethrow
try
    try
        error('Inner:err', 'inner failure');
    catch innerErr
        fprintf('Handling inner, will rethrow\n');
        rethrow(innerErr);
    end
catch outerErr
    fprintf('Outer caught: %s\n', outerErr.message);
end

% err.getReport() (a method) / getReport(err) (function form) prints a formatted
% multi-line report including the identifier, message, and a stack trace - standard
% in real MATLAB. CONFIRMED INCOMPATIBILITY: not implemented in Octave 9.2 either as
% getReport(err) or err.getReport() (verified). Octave's portable substitute is
% building the same information manually from err.message/err.identifier/err.stack.
try
    error('Demo:err', 'demo failure for the error-report example');
catch err
    fprintf('%s: %s\n', err.identifier, err.message);
    if ~isempty(err.stack)
        fprintf('  at %s (line %d)\n', err.stack(1).name, err.stack(1).line);
    end
end

disp('Program continued after all errors were handled');
