#!/usr/bin/env perl
use strict;
use warnings;

# @_ is the implicit args array; no named parameters by default.
sub add {
    my ($a, $b) = @_;
    return $a + $b;
}
print "add(2,3) = ", add(2,3), "\n";

# Context-sensitivity: the same sub can behave differently
# depending on whether it's called in list or scalar context.
sub stats {
    my @nums = @_;
    if (wantarray()) {
        return (min => (sort { $a <=> $b } @nums)[0], max => (sort { $b <=> $a } @nums)[0]);
    } elsif (defined wantarray()) {
        return scalar(@nums);   # count, in scalar context
    } else {
        return;                  # void context
    }
}

my %s = stats(4, 8, 1, 9, 3);
print "list context: min=$s{min} max=$s{max}\n";

my $count = stats(4, 8, 1, 9, 3);
print "scalar context: count=$count\n";

stats(4, 8, 1, 9, 3);  # void context, no output expected from the sub itself
print "called in void context too (no return value used)\n";
