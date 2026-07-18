#!/usr/bin/env perl
use strict;
use warnings;

my @nums = (5, 2, 9, 1, 7, 3);

# slices
my @slice = @nums[1..3];
print "slice [1..3]: @slice\n";

# map / grep
my @squares = map { $_ ** 2 } @nums;
my @evens   = grep { $_ % 2 == 0 } @nums;
print "squares: @squares\n";
print "evens: @evens\n";

# sort with custom comparator (descending)
my @desc = sort { $b <=> $a } @nums;
print "desc: @desc\n";

# hash of arrays, and sort by value
my %score = (alice => 90, bob => 75, carol => 88);
my @by_score_desc = sort { $score{$b} <=> $score{$a} } keys %score;
print "ranked: @by_score_desc\n";

# hash slice
my @wanted = @score{qw(alice carol)};
print "hash slice: @wanted\n";
