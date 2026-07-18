#!/usr/bin/env perl
use strict;
use warnings;

my $name = "World";

# Interpolation only happens in double quotes.
print "double: Hello $name\n";
print 'single: Hello $name', "\n";

# Regex matching with =~ and m//
my $text = "The quick brown fox jumps over 42 lazy dogs";
if ($text =~ /(\d+)/) {
    print "found number: $1\n";
}

my @words = ($text =~ /(\w+)/g);
print "word count: ", scalar(@words), "\n";

# Substitution with s///
(my $censored = $text) =~ s/fox/cat/;
print "original:  $text\n";
print "censored:  $censored\n";

# Global substitution + capture groups
(my $swapped = "2026-07-19") =~ s/(\d+)-(\d+)-(\d+)/$3\/$2\/$1/;
print "date swap: $swapped\n";
