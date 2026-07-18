#!/usr/bin/env perl
use strict;
use warnings;

# Anonymous subs: sub { ... } with no name, storable in a scalar like any
# other value -- Perl's first-class-function primitive.
my $square = sub { my $n = shift; return $n * $n; };
print "square(5) = ", $square->(5), "\n";

# Closures: an anonymous sub captures its enclosing lexical scope by
# reference, not by value -- each call to make_counter gets its OWN $count.
sub make_counter {
    my $count = shift // 0;
    return sub { return $count++; };
}
my $counter_a = make_counter();
my $counter_b = make_counter(100);
print "counter_a: ", $counter_a->(), ", ", $counter_a->(), ", ", $counter_a->(), "\n";
print "counter_b: ", $counter_b->(), ", ", $counter_b->(), "\n";
print "independent state confirmed: counter_a next=", $counter_a->(), " counter_b next=", $counter_b->(), "\n";

# map/grep in a functional framing: build a small pipeline of pure functions
my @data = (1..10);
my $pipeline = sub {
    my @nums = @_;
    return map { $_ ** 2 } grep { $_ % 2 == 0 } @nums;
};
print "pipeline (square of evens): ", join(",", $pipeline->(@data)), "\n";

# Function composition: build a new function from two others
sub compose {
    my ($f, $g) = @_;
    return sub { return $f->($g->(@_)); };
}
my $add_one   = sub { return $_[0] + 1; };
my $times_two = sub { return $_[0] * 2; };
my $composed  = compose($times_two, $add_one);   # times_two(add_one(x))
print "compose: (5+1)*2 = ", $composed->(5), "\n";

# Higher-order function taking a callback
sub apply_n_times {
    my ($n, $fn, $val) = @_;
    $val = $fn->($val) for 1..$n;
    return $val;
}
print "apply_n_times(3, double, 2): ", apply_n_times(3, $times_two, 2), "\n";
