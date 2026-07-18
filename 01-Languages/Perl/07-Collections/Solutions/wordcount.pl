#!/usr/bin/env perl
use strict;
use warnings;

my @words = qw(apple banana apple cherry banana apple);

my %count;
$count{$_}++ for @words;

my @ranked = sort {
    $count{$b} <=> $count{$a}   # highest count first
        || $a cmp $b            # tie-break alphabetically
} keys %count;

for my $w (@ranked) {
    print "$w: $count{$w}\n";
}
