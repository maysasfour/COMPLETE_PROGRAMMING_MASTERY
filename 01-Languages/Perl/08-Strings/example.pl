#!/usr/bin/env perl
use strict;
use warnings;

my $name = "World";

# Double quotes interpolate variables; SINGLE quotes do NOT -- verified live.
print "double-quoted: Hello, $name!\n";
print 'single-quoted: Hello, $name!', "\n";   # literally prints $name, unexpanded

# Basic regex matching with =~ and m//
my $text = "The quick brown fox jumps over 42 lazy dogs";
if ($text =~ m/(\d+)/) {
    print "found a number: $1\n";     # $1 captures the matched group
}

my @words = ($text =~ m/(\w+)/g);      # /g in list context returns ALL matches
print "word count via regex: ", scalar(@words), "\n";

# Real substitution demo: s/// with a capture group and back-reference
my $sentence = "cat sat on the cat mat";
(my $swapped = $sentence) =~ s/cat/dog/g;
print "substituted: $swapped\n";

my $date = "2026-07-19";
(my $reformatted = $date) =~ s/(\d{4})-(\d{2})-(\d{2})/$2\/$3\/$1/;
print "reformatted date: $reformatted\n";

# Case-insensitive match, and tr/// for character-level transliteration/counting
print "case-insensitive match: ", ($text =~ /QUICK/i ? "yes" : "no"), "\n";

my $vowels = ($text =~ tr/aeiouAEIOU//);   # tr in this form COUNTS matches
print "vowel count: $vowels\n";

# String building: heredoc-like multi-line via qq{} and repeated concatenation
my $multi = "Line one.\n" . "Line two.\n";
print $multi;
