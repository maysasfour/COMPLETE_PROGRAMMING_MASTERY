#!/usr/bin/env perl
use strict;
use warnings;

# Ex4: Given %h (unique values), build and print the inverted hash (value -> key).
sub invert_hash {
    my (%h) = @_;
    my %inverted;
    while (my ($k, $v) = each %h) {
        $inverted{$v} = $k;
    }
    return %inverted;
}

my %capitals = (
    France  => "Paris",
    Japan   => "Tokyo",
    Egypt   => "Cairo",
);

my %inverted = invert_hash(%capitals);

print "original:\n";
for my $k (sort keys %capitals) {
    print "  $k => $capitals{$k}\n";
}

print "inverted:\n";
for my $k (sort keys %inverted) {
    print "  $k => $inverted{$k}\n";
}
