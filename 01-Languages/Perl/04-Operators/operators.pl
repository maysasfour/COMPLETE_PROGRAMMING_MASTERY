#!/usr/bin/env perl
use strict;
use warnings;

# String concatenation vs numeric addition
my $a = "10";
my $b = "5";
print "concat: ", $a . $b, "\n";     # "105"
print "add:    ", $a + $b, "\n";     # 15

# Numeric equality coerces both sides to numbers.
# String equality compares the actual characters.
print "\"10\" == \"10.0\" -> ", ("10" == "10.0" ? "true" : "false"), "\n";
print "\"10\" eq \"10.0\" -> ", ("10" eq "10.0" ? "true" : "false"), "\n";

# lt/gt do lexicographic string comparison, not numeric.
print "\"9\" lt \"10\" (string) -> ", ("9" lt "10" ? "true" : "false"), "\n";
print "9 < 10 (numeric)         -> ", (9 < 10 ? "true" : "false"), "\n";

# repeat operator
print "x" x 5, "\n";
my @r = (1,2) x 3;
print "@r\n";
