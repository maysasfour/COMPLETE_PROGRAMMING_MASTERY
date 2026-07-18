#!/usr/bin/env perl
use strict;
use warnings;

# Traditional mechanism: eval/die/$@
sub risky_divide {
    my ($a, $b) = @_;
    die "cannot divide by zero\n" if $b == 0;
    return $a / $b;
}

my $result = eval { risky_divide(10, 0) };
if ($@) {
    print "traditional caught: $@";
} else {
    print "result: $result\n";
}

# Modern mechanism: native try/catch (feature added in 5.34, stable-ish by 5.38)
use feature 'try';
no warnings 'experimental::try';

sub might_fail {
    my ($n) = @_;
    die "negative not allowed\n" if $n < 0;
    return sqrt($n);
}

try {
    my $r = might_fail(-5);
    print "unreachable: $r\n";
} catch ($e) {
    print "try/catch caught: $e";
}

try {
    my $r = might_fail(16);
    print "try/catch success: $r\n";
} catch ($e) {
    print "unreachable\n";
}
