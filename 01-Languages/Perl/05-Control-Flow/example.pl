#!/usr/bin/env perl
use strict;
use warnings;

for my $n (5, -3, 0) {
    if ($n > 0) {
        print "$n: positive\n";
    } elsif ($n < 0) {
        print "$n: negative\n";
    } else {
        print "$n: zero\n";
    }
}

# `unless` is inverted `if`; postfix forms read like English guard clauses.
my @empty = ();
print "empty list\n" unless @empty;
print "not run\n" if @empty;

print "skip\n" unless 1;    # never prints (unless-false postfix)
print "run\n" if 1;

# foreach (foreach and for are the same keyword in Perl)
foreach my $fruit (qw(apple banana cherry)) {
    print "fruit: $fruit\n";
}

# while / until, including postfix forms
my $i = 0;
while ($i < 3) {
    print "while i=$i\n";
    $i++;
}

my $j = 3;
$j-- and print "postfix until countdown: $j\n" until $j == 0;

# C-style for
for (my $k = 0; $k < 3; $k++) {
    print "cfor k=$k\n";
}
