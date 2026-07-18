#!/usr/bin/env perl
use strict;
use warnings;

# 1. Sort by length, ties alphabetically
my @words = qw(pear apple kiwi banana fig);
my @by_len = sort { length($a) <=> length($b) or $a cmp $b } @words;
print "by length: @by_len\n";

# 2. Out-of-stock items
my %inventory = (apples => 5, bananas => 0, cherries => 12, dates => 0);
my @out_of_stock = grep { $inventory{$_} == 0 } keys %inventory;
print "out of stock: ", join(", ", sort @out_of_stock), "\n";

# 3. Squares of odd numbers
my @nums = (1..10);
my @odd_squares = map { $_ * $_ } grep { $_ % 2 == 1 } @nums;
print "odd squares: @odd_squares\n";
