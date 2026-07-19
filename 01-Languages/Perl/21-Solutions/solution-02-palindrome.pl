#!/usr/bin/env perl
use strict;
use warnings;

# Ex2: Write sub is_palindrome($str) that ignores case and non-alnum chars.
sub is_palindrome {
    my ($str) = @_;
    (my $clean = lc $str) =~ s/[^a-z0-9]//g;
    return $clean eq reverse($clean);
}

my @cases = (
    "A man, a plan, a canal: Panama",
    "Was it a car or a cat I saw?",
    "Hello, World!",
    "Madam, I'm Adam",
);

for my $c (@cases) {
    my $result = is_palindrome($c) ? "PALINDROME" : "not a palindrome";
    print "\"$c\" -> $result\n";
}
