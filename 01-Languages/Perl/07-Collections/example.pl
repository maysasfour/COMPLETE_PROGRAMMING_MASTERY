#!/usr/bin/env perl
use strict;
use warnings;

my @nums = (5, 3, 8, 1, 9, 2);

# Slices: pull out several elements/keys at once with the SAME sigil rule
# as before but a PLURAL sigil (@ for a slice, even of a %hash or a single
# scalar's worth of array elements).
my @first_three = @nums[0..2];
print "array slice: @first_three\n";

my %h = (a => 1, b => 2, c => 3, d => 4);
my @vals = @h{qw(a c)};    # hash slice: @ sigil even though %h is a hash
print "hash slice: @vals\n";

# map: transform every element
my @doubled = map { $_ * 2 } @nums;
print "map (doubled): @doubled\n";

# grep: filter
my @evens = grep { $_ % 2 == 0 } @nums;
print "grep (evens): @evens\n";

# sort with a custom comparator (numeric ascending, then descending)
my @asc  = sort { $a <=> $b } @nums;
my @desc = sort { $b <=> $a } @nums;
print "sort asc:  @asc\n";
print "sort desc: @desc\n";

# Sorting a hash by value, a very common real-world pattern
my %scores = (alice => 90, bob => 72, carol => 88);
my @by_score_desc = sort { $scores{$b} <=> $scores{$a} } keys %scores;
print "ranked: ", join(", ", map { "$_=$scores{$_}" } @by_score_desc), "\n";

# Chaining map/grep/sort together, functional-pipeline style
my @result = sort { $a <=> $b } grep { $_ > 10 } map { $_ * 3 } @nums;
print "chained (x*3, >10, sorted): @result\n";
