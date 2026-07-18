#!/usr/bin/env perl
use strict;
use warnings;

sub min_max {
    my @nums = sort { $a <=> $b } @_;
    if (wantarray()) {
        return ($nums[0], $nums[-1]);
    }
    return "$nums[0]-$nums[-1]";
}

my ($lo, $hi) = min_max(5, 2, 9, 1);
print "list: lo=$lo hi=$hi\n";

my $range = min_max(5, 2, 9, 1);
print "scalar: $range\n";
