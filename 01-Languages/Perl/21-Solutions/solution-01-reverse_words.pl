#!/usr/bin/env perl
use strict;
use warnings;

# Ex1: Given a sentence string, print the words in reverse order.
sub reverse_words {
    my ($sentence) = @_;
    my @words = split /\s+/, $sentence;
    return join ' ', reverse @words;
}

my $sentence = "the quick brown fox jumps over the lazy dog";
print "input:  $sentence\n";
print "output: ", reverse_words($sentence), "\n";
