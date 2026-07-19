% example.m - Lesson 05: Control flow

% if / elseif / else
score = 72;
if score >= 90
    grade = 'A';
elseif score >= 70
    grade = 'B';
else
    grade = 'C';
end
fprintf('Grade: %s\n', grade);

% for loop over a row vector (columns of a matrix, one at a time)
total = 0;
for i = 1:5
    total = total + i;
end
fprintf('Sum 1..5 = %d\n', total);

% for over an explicit vector
for v = [10 20 30]
    fprintf('v = %d\n', v);
end

% while loop
n = 1;
count = 0;
while n < 100
    n = n * 2;
    count = count + 1;
end
fprintf('Doublings to exceed 100: %d (n=%d)\n', count, n);

% switch/case (case-insensitive to nothing - compares by value, strings via strcmp semantics)
day = 'Tue';
switch day
    case 'Mon'
        disp('Start of week');
    case {'Tue', 'Wed', 'Thu'}
        disp('Midweek');
    case 'Fri'
        disp('Almost weekend');
    otherwise
        disp('Weekend');
end

% break / continue
for k = 1:10
    if mod(k, 2) == 0
        continue
    end
    if k > 7
        break
    end
    fprintf('odd: %d\n', k);
end
