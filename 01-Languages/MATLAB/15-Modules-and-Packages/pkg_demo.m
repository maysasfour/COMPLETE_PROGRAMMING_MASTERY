% demo.m - Lesson 15: exercising the +geometry namespace package
% Run with: octave-cli demo.m

fprintf('circle_area(2) via package  = %.4f\n', geometry.circle_area(2));
fprintf('circle_circumference(2)     = %.4f\n', geometry.circle_circumference(2));
fprintf('shapes.square_area(3) (nested pkg) = %.4f\n', geometry.shapes.square_area(3));

p = geometry.Point(3, 4);
fprintf('geometry.Point(3,4).distance_to_origin() = %.4f\n', p.distance_to_origin());

% Calling WITHOUT the package prefix fails - the function does not exist
% in the base namespace, only inside +geometry. Demonstrated with try/catch
% so this script itself keeps running (matches Lesson 09's error-handling style).
try
  circle_area(2); %#ok<*NOPRT>
  disp('unexpected: unqualified call succeeded')
catch err
  fprintf('Expected failure calling unqualified circle_area(2): %s\n', err.message);
end
