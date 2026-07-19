#!/usr/bin/env perl
use strict;
use warnings;

# Ex8: Write a memoized Fibonacci using a closure over a private %cache hash.
sub make_fib {
    my %cache;
    my $fib;
    $fib = sub {
        my ($n) = @_;
        return $n if $n < 2;
        return $cache{$n} //= $fib->($n - 1) + $fib->($n - 2);
    };
    return $fib;
}

my $fib = make_fib();
print "fib($_) = ", $fib->($_), "\n" for (0, 1, 2, 5, 10, 20, 30);
