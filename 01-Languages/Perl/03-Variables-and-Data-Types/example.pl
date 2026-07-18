#!/usr/bin/env perl
# `use strict` and `use warnings` are, in practice, mandatory in modern
# Perl: without `strict`, an undeclared bareword like $totall (a typo of
# $total) silently auto-vivifies as a brand-new global variable instead of
# raising an error -- a classic, very hard-to-spot Perl bug. Without
# `warnings`, using an undefined value in a numeric/string context silently
# produces 0/"" instead of telling you something is wrong. Every reputable
# style guide (perlcritic, PBP) treats both as non-negotiable.
use strict;
use warnings;

# Scalars: numbers, strings, references -- one type, decided by context.
my $int_like   = 42;
my $float_like = 3.14;
my $string     = "hello";
my $undef_val;                 # undef until assigned

print "Scalars: $int_like $float_like $string ", (defined $undef_val ? "defined" : "undef"), "\n";

# Arrays: ordered, 0-indexed, growable lists of scalars.
my @arr = (10, 20, 30);
push @arr, 40;
print "Array: @arr, count=", scalar(@arr), ", last index=$#arr\n";

# Hashes: unordered key/value maps.
my %hash = (name => "Ada", lang => "Perl");
$hash{year} = 1843;
print "Hash: ", join(", ", map { "$_=$hash{$_}" } sort keys %hash), "\n";

# `my` creates a LEXICALLY scoped variable -- visible only within the
# enclosing block, proven below: $lexical does not leak out of the if-block.
{
    my $lexical = "block-scoped";
    print "inside block: $lexical\n";
}
# print $lexical;  # would be a compile error: "Global symbol $lexical requires explicit package name"

# Without `my`, an assignment creates a PACKAGE GLOBAL living in the current
# package's symbol table (here, main::) -- visible everywhere, the opposite
# of lexical scoping. This is legal Perl but almost always the wrong choice
# in real code, which is exactly why `use strict 'vars'` forbids bare
# globals unless fully qualified or pre-declared with `our`.
our $package_global = "I live in %main::";
print "global via \$main::package_global: $main::package_global\n";

sub demonstrate_scope {
    # A `my` variable declared in an outer scope IS visible to nested
    # blocks/subs defined within that same lexical scope (closures rely on
    # exactly this), but NOT to code merely *called* from elsewhere.
    my $outer = "visible via closure";
    return sub { return $outer; };
}
print demonstrate_scope()->(), "\n";
