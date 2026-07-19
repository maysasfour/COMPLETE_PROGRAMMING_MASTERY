#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;

# Ex7: Read a text file, count word frequency (case-insensitive), print top 3.
sub top_word_frequencies {
    my ($filename, $top_n) = @_;
    open my $fh, '<', $filename or die "cannot open $filename: $!";
    my %freq;
    while (my $line = <$fh>) {
        chomp $line;
        for my $word (split /\W+/, lc $line) {
            next unless length $word;
            $freq{$word}++;
        }
    }
    close $fh;

    my @top = (sort { $freq{$b} <=> $freq{$a} or $a cmp $b } keys %freq)[0 .. $top_n - 1];
    return map { [$_, $freq{$_}] } @top;
}

# Resolve relative to this script's directory regardless of cwd.
my $file = "$FindBin::Bin/sample.txt";

for my $pair (top_word_frequencies($file, 3)) {
    my ($word, $count) = @$pair;
    print "$word: $count\n";
}
