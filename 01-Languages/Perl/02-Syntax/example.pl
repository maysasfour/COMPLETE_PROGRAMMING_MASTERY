#!/usr/bin/env perl
use strict;
use warnings;

# Semicolons ARE required to separate statements (unlike Ruby/Python/JS/Kotlin
# elsewhere in this repo, where newlines can end a statement). Leaving one
# off is a real, common syntax error -- try deleting one below and Perl
# refuses to compile at all.
my $x = 1;
my $y = 2;
print "sum: ", $x + $y, "\n";

# Sigils mark a variable's ACCESS type, not a fixed "kind" tied to the name:
#   $name  -> a single scalar value
#   @name  -> an array (list)
#   %name  -> a hash (key/value map)
# Verified live below: the bareword "thing" is used simultaneously as a
# scalar, an array, and a hash -- three genuinely independent variables that
# happen to share one name, distinguished only by sigil.
my $thing = "I am a scalar";
my @thing = (1, 2, 3);
my %thing = (a => 1, b => 2);

print "\$thing  = $thing\n";
print "\@thing  = @thing\n";
print "\%thing  = ", join(", ", map { "$_=$thing{$_}" } sort keys %thing), "\n";

# Proof they are independently addressable, not aliases of one storage slot:
$thing[0] = 99;                 # mutate the array
$thing{a} = 42;                 # mutate the hash
print "after mutation: \$thing=$thing \@thing=@thing \%thing.a=$thing{a}\n";
