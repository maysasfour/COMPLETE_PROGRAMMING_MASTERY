#!/usr/bin/env perl
use strict;
use warnings;
use JSON::PP;

my $tmpfile = "scratch_notes.txt";

# Write
open(my $out, '>', $tmpfile) or die "cannot open $tmpfile: $!";
print $out "line one\n";
print $out "line two\n";
print $out "line three\n";
close $out;

# Read line by line
open(my $in, '<', $tmpfile) or die "cannot open $tmpfile: $!";
while (my $line = <$in>) {
    chomp $line;
    print "read: $line\n";
}
close $in;

# JSON::PP is bundled with this Perl - verified live.
my %data = (name => "Ada Lovelace", year => 1815, tags => ["mathematician", "programmer"]);
my $json_text = encode_json(\%data);
print "encoded: $json_text\n";

my $decoded = decode_json($json_text);
print "decoded name: $decoded->{name}, year: $decoded->{year}\n";

unlink $tmpfile;
print "cleaned up $tmpfile\n";
