#!/usr/bin/env perl
use strict;
use warnings;

# Every sub receives its arguments as the array @_ -- no named parameter
# list in the signature by default (this course does not use the newer,
# still-experimental `signatures` feature, to show the traditional idiom
# every real Perl codebase must be able to read).
sub add {
    my ($a, $b) = @_;    # unpack @_ into named lexicals -- the idiomatic first line
    return $a + $b;
}
print "add(2,3) = ", add(2, 3), "\n";

# @_ is literally the caller's argument list -- with no `my` unpacking,
# @_ is visible directly, and (importantly) elements of @_ ALIAS the
# caller's original variables rather than copying them.
sub increment_in_place {
    $_[0]++;    # mutates the caller's variable directly via @_ aliasing
}
my $counter = 10;
increment_in_place($counter);
print "counter after increment_in_place: $counter\n";

# CONTEXT SENSITIVITY: the same sub can behave differently depending on
# whether it's called in list context or scalar context. `wantarray`
# reports which. Verified live below with the identical sub call, assigned
# two different ways.
sub context_demo {
    if (wantarray()) {
        return (1, 2, 3);          # list context: return a list
    } else {
        return "scalar-mode";      # scalar context: return one value
    }
}
my @as_list  = context_demo();     # list context
my $as_scalar = context_demo();    # scalar context
print "list context result:   @as_list\n";
print "scalar context result: $as_scalar\n";

# A subtler, very common version of the same phenomenon: an array itself
# evaluates to its ELEMENT COUNT in scalar context, not its last element.
my @arr = (10, 20, 30);
my $count = @arr;     # scalar context forced by assignment to a scalar
print "\@arr in scalar context = $count (its count, not last element)\n";
