% example.m - Lesson 01: Setup and first script
% Run with: octave-cli example.m   (or, with real MATLAB: matlab -batch "example")

disp('Hello, MATLAB/Octave!')

% version() and OCTAVE_VERSION are how a script can tell what it is running under
if exist('OCTAVE_VERSION', 'builtin')
    fprintf('Running on GNU Octave %s\n', OCTAVE_VERSION());
else
    fprintf('Running on MATLAB %s\n', version());
end

% pwd shows the current working directory - .m files run relative to this
fprintf('Current folder: %s\n', pwd());
