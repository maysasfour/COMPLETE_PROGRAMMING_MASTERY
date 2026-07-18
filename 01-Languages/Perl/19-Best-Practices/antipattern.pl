#!/usr/bin/env perl
# ANTI-PATTERN: no strict/warnings, cryptic names, no error checking.
# This deliberately reproduces a classic "write-only Perl" bug.

$n = 5; $r = 1; for ($i=1;$i<=$n;$i++){$r*=$i;}
print "$r\n";

open(F, "does_not_exist_at_all.txt");
print "F opened (but did it really succeed?)\n";
while (<F>) { print; }
close(F);
print "done, silently\n";
