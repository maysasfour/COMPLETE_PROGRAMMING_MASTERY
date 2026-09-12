function a = circle_area(r)
  % Function inside the +geometry package/namespace folder.
  % Callers must qualify it as geometry.circle_area(r) - the +prefix
  % on the folder name is what creates the namespace; it is invisible
  % to callers (never typed as +geometry.circle_area).
  a = pi * r.^2;
endfunction
