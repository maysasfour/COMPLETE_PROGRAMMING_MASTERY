#!/usr/bin/env perl
use strict;
use warnings;

# Scalars: numbers, strings, references - all one type "scalar"
my $int    = 42;
my $float  = 3.14;
my $str    = "hello";
my $undef;              # undef by default

# Arrays: ordered, 0-indexed, heterogeneous
my @arr = (1, "two", 3.0, [4,5]);

# Hashes: unordered key/value
my %hash = (name => "Ada", year => 1815);

print "int=$int float=$float str=$str undef is ", (defined $undef ? "defined" : "undef"), "\n";
print "arr has ", scalar(@arr), " elements; arr[1]=$arr[1]\n";
print "hash{name}=$hash{name} hash{year}=$hash{year}\n";

# my (lexical) vs our (package global) vs no declaration under strict
our $package_global = "visible via full name too";
{
    my $lexical = "only visible in this block";
    print "inside block: $lexical\n";
}
# print $lexical;  # would be a compile error: "Global symbol requires explicit package name"
print "package_global=$package_global, also as \$main::package_global=$main::package_global\n";
