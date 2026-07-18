#!/usr/bin/env perl
use strict;
use warnings;

my $age = 20;
if ($age >= 18) { print "adult\n"; } elsif ($age >= 13) { print "teen\n"; } else { print "child\n"; }

unless ($age < 18) { print "not a minor\n"; }

print "postfix if\n" if $age >= 18;
print "postfix unless\n" unless $age < 18;

for my $i (1..3) { print "for: $i\n"; }

my @fruits = ("apple","banana","cherry");
foreach my $f (@fruits) { print "foreach: $f\n"; }

my $n = 0;
while ($n < 3) { print "while: $n\n"; $n++; }

my $m = 0;
until ($m >= 3) { print "until: $m\n"; $m++; }
