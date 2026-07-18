#!/usr/bin/env perl
use strict;
use warnings;
use lib '.';
use MathUtils qw(square cube);

print "square(4) = ", square(4), "\n";
print "cube(3) = ", cube(3), "\n";

print "\@INC contains:\n";
print "  $_\n" for @INC;
