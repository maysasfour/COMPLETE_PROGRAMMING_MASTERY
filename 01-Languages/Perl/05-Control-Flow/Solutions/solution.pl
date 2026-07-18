#!/usr/bin/env perl
use strict;
use warnings;

# 1. FizzBuzz
for my $n (1..20) {
    if ($n % 15 == 0) { print "FizzBuzz\n"; }
    elsif ($n % 3 == 0) { print "Fizz\n"; }
    elsif ($n % 5 == 0) { print "Buzz\n"; }
    else { print "$n\n"; }
}

# 2. Grades
my @scores = (95, 82, 71, 40);
for my $score (@scores) {
    my $grade;
    if    ($score >= 90) { $grade = "A"; }
    elsif ($score >= 80) { $grade = "B"; }
    elsif ($score >= 70) { $grade = "C"; }
    else                 { $grade = "F"; }
    print "$score -> $grade\n";
}

# 3. Countdown with until
my $n = 5;
until ($n < 1) {
    print "countdown: $n\n";
    $n--;
}
