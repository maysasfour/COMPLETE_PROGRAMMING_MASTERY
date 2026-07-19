% example.m - Lesson 11: OOP via classdef

a = Animal('Generic');
a.speak();
disp(a.describe());

d = Dog('Rex');
d.speak();               % polymorphism: Dog's override runs, not Animal's
fprintf('isa(d, ''Animal'') = %d\n', isa(d, 'Animal'));

% Value semantics: methods that "mutate" must return the changed object
d = d.learnTrick('sit');
d = d.learnTrick('roll over');
fprintf('Tricks: %s\n', strjoin(d.tricks, ', '));

d2 = d;                 % copies the VALUE
d2 = d2.learnTrick('speak');
fprintf('d has %d tricks, d2 has %d tricks (value semantics -> independent)\n', ...
        numel(d.tricks), numel(d2.tricks));

% Handle classes: reference semantics
c1 = Counter();
c1.increment();
c1.increment();
c2 = c1;                 % copies the REFERENCE, not the value
c2.increment();
fprintf('c1.count = %d, c2.count = %d (handle -> same object, both see 3)\n', ...
        c1.count, c2.count);
