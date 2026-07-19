% example.m - Lesson 10: File I/O
% Writes into this lesson's own folder, then reads it back and cleans up.

folder = fileparts(mfilename('fullpath'));
txtFile = fullfile(folder, 'demo.txt');
csvFile = fullfile(folder, 'demo.csv');
matFile = fullfile(folder, 'demo.mat');

% Low-level text I/O: fopen/fprintf/fclose
fid = fopen(txtFile, 'w');
fprintf(fid, 'line one\n');
fprintf(fid, 'line two: %d\n', 42);
fclose(fid);
fprintf('Wrote %s\n', txtFile);

% Read it back line by line
fid = fopen(txtFile, 'r');
while ~feof(fid)
    line = fgetl(fid);
    if ischar(line)
        fprintf('Read: %s\n', line);
    end
end
fclose(fid);

% Whole-file read as one string
allText = fileread(txtFile);
fprintf('fileread got %d characters\n', length(allText));

% CSV via csvwrite/csvread (numeric-only, simple case) and dlmwrite/dlmread for more control
M = [1 2 3; 4 5 6];
csvwrite(csvFile, M);
M2 = csvread(csvFile);
disp(M2)
fprintf('Round-trip matches: %d\n', isequal(M, M2));

% Binary MAT format: save/load native workspace variables
config.name = 'demo';
config.value = 99;
save(matFile, 'config');
clear config
loaded = load(matFile);
fprintf('Loaded config.name = %s, value = %d\n', loaded.config.name, loaded.config.value);

% exist() checks for files/variables/functions before touching them
fprintf('exist(txtFile) = %d (2 = file on path)\n', exist(txtFile, 'file'));

% Clean up demo files so the lesson folder stays clean between runs
delete(txtFile);
delete(csvFile);
delete(matFile);
fprintf('exist(txtFile) after delete = %d\n', exist(txtFile, 'file'));
