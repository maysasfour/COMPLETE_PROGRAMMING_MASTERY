#!/usr/bin/env perl
use strict;
use warnings;

# Perl keeps NUMERIC and STRING operators textually distinct -- unlike most
# languages here, `==`/`!=`/`<`/`>` always compare NUMERICALLY (coercing
# operands to numbers first), while `eq`/`ne`/`lt`/`gt`/`le`/`ge` always
# compare as STRINGS. Using the wrong pair is a real, very common bug.

my $num_a = "10";
my $num_b = "10.0";

print "numeric == : ", ($num_a == $num_b ? "true" : "false"), "\n";   # numeric compare
print "string  eq : ", ($num_a eq $num_b ? "true" : "false"), "\n";   # string compare

# Verified live: "10" and "10.0" are numerically EQUAL (both coerce to 10)
# but NOT string-equal (different characters) -- the exact gotcha this
# lesson exists to demonstrate.

print "concat (.)  : ", "foo" . "bar" . 3, "\n";   # `.` concatenates
print "repeat (x)  : ", "ab" x 3, "\n";            # `x` repeats a string

my @list = (1, 2) x 3;   # `x` on a list repeats the whole list
print "list repeat : @list\n";

# Arithmetic
print "5 ** 2      : ", 5 ** 2, "\n";   # exponent
print "7 % 3       : ", 7 % 3, "\n";    # modulo

# String vs numeric sort ordering, another consequence of the same split.
# GOTCHA (found live while writing this example): `sort { $a <=> $b } ...`
# relies on Perl's own PACKAGE GLOBALS $a/$b as the comparator's two
# arguments -- if the surrounding code also has a lexical `my $a`/`my $b` in
# scope, it silently shadows those globals inside the sort block, producing
# both a "used in sort comparison" warning AND a wrong, unsorted result. The
# fix (already applied above) is simply never naming lexicals $a/$b at all.
my @nums = (10, 9, 2, 1);
print "numeric sort: ", join(",", sort { $a <=> $b } @nums), "\n";   # <=> numeric compare
print "string  sort: ", join(",", sort @nums), "\n";                  # default sort is stringwise!

# Ternary and defined-or
my $maybe_undef;
my $val = $maybe_undef // "default";   # // is defined-or, NOT boolean-or
print "defined-or  : $val\n";
