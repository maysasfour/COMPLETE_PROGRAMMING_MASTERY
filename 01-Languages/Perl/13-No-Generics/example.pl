#!/usr/bin/env perl
use strict;
use warnings;

# Perl has NO static type system at all -- no compile-time type checking,
# and therefore no generics/templates/type-parameters of any kind (the
# same gap this repository documents for Python/PHP/Ruby elsewhere). Every
# scalar can hold any kind of value, every array/hash can mix types freely,
# and the interpreter does not check or enforce container element types.

package Stack {
    sub new  { return bless { items => [] }, shift; }
    sub push { my $self = shift; push @{ $self->{items} }, @_; return $self; }
    sub pop  { my $self = shift; return pop @{ $self->{items} }; }
    sub size { return scalar @{ $_[0]->{items} }; }
}

# The SAME untyped Stack class happily accepts a number, a string, an
# arrayref, and a blessed object -- with zero complaint from the language,
# since there is no generic constraint (like Java's <T>, TypeScript's
# generics, or C++ templates) to enforce homogeneity.
my $stack = Stack->new;
$stack->push(42);                       # a number
$stack->push("hello");                  # a string
$stack->push([1, 2, 3]);                # an arrayref
$stack->push(Stack->new);               # a blessed object -- another Stack!

print "stack size after 4 genuinely mismatched pushes: ", $stack->size, "\n";
while (my $item = $stack->pop) {
    print "popped: ", ref($item) || (($item =~ /^\d+$/) ? "NUMBER" : "STRING"), " -> ",
          (ref($item) eq 'ARRAY' ? "[@$item]" : (ref($item) ? ref($item) : $item)), "\n";
}

# The idiomatic substitute for "type safety" in Perl is DISCIPLINE plus, at
# most, a runtime `ref()`/`Scalar::Util::blessed` check at a boundary --
# never a compile-time guarantee, since there is nothing that compiles
# types in the first place.
use Scalar::Util qw(looks_like_number);
sub sum_only_numbers {
    my @nums = grep { looks_like_number($_) } @_;
    my $sum = 0;
    $sum += $_ for @nums;
    return $sum;
}
print "sum_only_numbers(1, 'two', 3, [4]): ", sum_only_numbers(1, 'two', 3, [4]), "\n";
