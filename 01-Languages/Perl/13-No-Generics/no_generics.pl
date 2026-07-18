#!/usr/bin/env perl
use strict;
use warnings;

# One "container" sub works on any element type at all - no type parameter needed.
sub first_element { my $listref = shift; return $listref->[0]; }

my @ints    = (1, 2, 3);
my @strings = ("a", "b", "c");
my @mixed   = (1, "two", 3.0, [4,5]);

print "first int:    ", first_element(\@ints), "\n";
print "first string: ", first_element(\@strings), "\n";
print "first mixed:  ", first_element(\@mixed), "\n";

# Nothing stops you mixing types in a single array/hash - there is no
# compile-time type check anywhere in this file.
push @ints, "not actually an int, and Perl does not care";
print "ints after mixing: @ints\n";
