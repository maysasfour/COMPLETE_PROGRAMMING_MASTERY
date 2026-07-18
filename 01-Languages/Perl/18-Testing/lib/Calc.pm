package Calc;
use strict;
use warnings;
use Exporter 'import';

our @EXPORT_OK = qw(add divide);

sub add { my ($a, $b) = @_; return $a + $b; }
sub divide {
    my ($a, $b) = @_;
    die "division by zero\n" if $b == 0;
    return $a / $b;
}

1;
