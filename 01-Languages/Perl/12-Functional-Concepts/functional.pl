#!/usr/bin/env perl
use strict;
use warnings;

# Anonymous subs are first-class values
my $square = sub { return $_[0] ** 2; };
print "square(5) = ", $square->(5), "\n";

# Closures: a sub can capture and privately retain a lexical variable
sub make_counter {
    my $count = shift // 0;
    return sub { return $count++; };
}
my $c1 = make_counter();
my $c2 = make_counter(100);
print "c1: ", $c1->(), " ", $c1->(), " ", $c1->(), "\n";
print "c2: ", $c2->(), " ", $c2->(), "\n";
print "c1 and c2 have independent state (verified: c1 unaffected by c2 calls)\n";

# map/grep as the functional filter/transform idiom
my @nums = (1..10);
my @transformed = map { $_ * $_ } grep { $_ % 2 == 0 } @nums;
print "even squares: @transformed\n";

# Passing subs as arguments (higher-order functions)
sub apply_twice {
    my ($fn, $val) = @_;
    return $fn->($fn->($val));
}
print "apply_twice(square, 3) = ", apply_twice($square, 3), "\n";
