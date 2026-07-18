#!/usr/bin/env perl
use strict;
use warnings;

# 1. max_of
sub max_of {
    my @nums = @_;
    my $max = $nums[0];
    for my $n (@nums) { $max = $n if $n > $max; }
    return $max;
}
print "max_of: ", max_of(3, 9, 2, 7), "\n";

# 2. greet with default arg
sub greet {
    my ($name, $greeting) = @_;
    $greeting //= "Hello";   # defined-or default
    return "$greeting, $name!";
}
print greet("Ada"), "\n";
print greet("Grace", "Hi"), "\n";

# 3. context-sensitive stats
sub stats {
    my @nums = @_;
    if (wantarray()) {
        my $min = $nums[0];
        my $max = $nums[0];
        my $sum = 0;
        for my $n (@nums) {
            $min = $n if $n < $min;
            $max = $n if $n > $max;
            $sum += $n;
        }
        return ($min, $max, $sum / scalar(@nums));
    } else {
        return scalar(@nums);
    }
}
my ($min, $max, $avg) = stats(4, 8, 15, 16, 23);
print "list context stats: min=$min max=$max avg=$avg\n";
my $count = stats(4, 8, 15, 16, 23);
print "scalar context stats: count=$count\n";
