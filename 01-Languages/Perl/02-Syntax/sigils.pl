#!/usr/bin/env perl
use strict;
use warnings;

# Three completely independent variables sharing the name "x",
# distinguished only by their sigil.
my $x = "I am a scalar";
my @x = ("I", "am", "an", "array");
my %x = (type => "I am a hash");

print "scalar \$x = $x\n";
print "array  \@x = @x\n";
print "hash   \%x{type} = $x{type}\n";

# Proof they are truly independent: mutating one doesn't touch the others.
$x = "scalar changed";
push @x, "extended";
print "\nafter mutation:\n";
print "\$x = $x\n";
print "\@x = @x\n";
