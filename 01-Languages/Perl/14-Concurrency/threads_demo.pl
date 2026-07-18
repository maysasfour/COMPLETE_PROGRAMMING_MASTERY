#!/usr/bin/env perl
use strict;
use warnings;
use threads;
use threads::shared;

my $counter :shared = 0;

sub worker {
    my $id = shift;
    for (1..1000) {
        lock($counter);
        $counter++;
    }
    return "worker $id done";
}

my @thr = map { threads->create(\&worker, $_) } (1..4);
my @results = map { $_->join() } @thr;

print "$_\n" for @results;
print "final counter (expect 4000): $counter\n";
