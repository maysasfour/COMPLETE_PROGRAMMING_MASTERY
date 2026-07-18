#!/usr/bin/env perl
use strict;
use warnings;
use JSON::PP;   # NOT built into perl core itself, but bundled with every
                 # modern Perl distribution (including this Git-for-Windows
                 # build) since it's a dual-life module -- confirmed live:
                 # `perl -MJSON::PP -e 1` succeeds with zero installs here.

my $path = "demo_output.txt";

# open/close and <FH> line reading
open(my $fh, '>', $path) or die "Cannot open $path for writing: $!";
print $fh "line one\n";
print $fh "line two\n";
print $fh "line three\n";
close($fh);

open(my $in, '<', $path) or die "Cannot open $path for reading: $!";
my @lines = <$in>;      # slurp all lines into a list
close($in);
print "read back ", scalar(@lines), " lines:\n";
print for @lines;

# Append mode
open(my $append_fh, '>>', $path) or die "Cannot append to $path: $!";
print $append_fh "line four (appended)\n";
close($append_fh);

open(my $in2, '<', $path) or die "Cannot reopen $path: $!";
my $line_count = 0;
while (my $line = <$in2>) { $line_count++; }
close($in2);
print "line count after append: $line_count\n";

# JSON::PP: encode/decode round-trip -- Perl's own equivalent of JSON.parse/stringify
my %data = (name => "Ada Lovelace", year => 1843, langs => ["Perl", "Analytical Engine"]);
my $json_text = encode_json(\%data);
print "encoded JSON: $json_text\n";

my $decoded = decode_json($json_text);
print "decoded name: $decoded->{name}, first lang: $decoded->{langs}[0]\n";

unlink($path) or warn "Could not delete $path: $!";
print "cleaned up $path\n";
