#!/usr/bin/env perl
use strict;
use warnings;

# Ex6: Write sub safe_divide($a,$b) using eval/die that returns undef and
# warns on divide-by-zero instead of crashing the whole script.
sub safe_divide {
    my ($a, $b) = @_;
    my $result = eval {
        die "division by zero\n" if $b == 0;
        return $a / $b;
    };
    if ($@) {
        warn "safe_divide($a, $b) failed: $@";
        return undef;
    }
    return $result;
}

my @pairs = ([10, 2], [7, 0], [9, 3]);
for my $pair (@pairs) {
    my ($a, $b) = @$pair;
    my $r = safe_divide($a, $b);
    print "safe_divide($a, $b) = ", (defined $r ? $r : "undef"), "\n";
}
print "script did not crash -- reached the end\n";
