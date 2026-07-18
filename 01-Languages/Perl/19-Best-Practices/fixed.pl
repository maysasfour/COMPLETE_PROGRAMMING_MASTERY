#!/usr/bin/env perl
use strict;
use warnings;

sub factorial {
    my ($n) = @_;
    my $result = 1;
    $result *= $_ for (1..$n);
    return $result;
}

print factorial(5), "\n";

open(my $fh, '<', 'does_not_exist_at_all.txt') or do {
    print "correctly detected open failure: $!\n";
};
