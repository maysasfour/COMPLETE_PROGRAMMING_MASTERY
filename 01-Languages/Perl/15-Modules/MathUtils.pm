package MathUtils;
use strict;
use warnings;
use Exporter 'import';

our @EXPORT_OK = qw(square cube average);

sub square  { my $n = shift; return $n * $n; }
sub cube    { my $n = shift; return $n ** 3; }
sub average { my @n = @_; my $s = 0; $s += $_ for @n; return $s / scalar(@n); }

1;   # a module file must return a true value -- this is that value
