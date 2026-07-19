#!/usr/bin/env perl
use strict;
use warnings;

# Ex3: Given @nums with duplicates, print unique values sorted numerically ascending.
sub unique_sorted {
    my @nums = @_;
    my %seen;
    my @unique = grep { !$seen{$_}++ } @nums;
    return sort { $a <=> $b } @unique;
}

my @nums = (5, 3, 8, 3, 1, 5, 9, 1, 0, 8, -2);
print "input:  (", join(', ', @nums), ")\n";
print "output: (", join(', ', unique_sorted(@nums)), ")\n";
