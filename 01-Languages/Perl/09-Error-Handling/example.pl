#!/usr/bin/env perl
use strict;
use warnings;
use feature 'try';
no warnings 'experimental::try';   # try/catch is stable-but-flagged-experimental as of 5.38

# Traditional Perl error handling: eval {} BLOCK + $@ (the error variable).
# `die` raises; an uncaught die at top level terminates the program.
sub risky_divide {
    my ($a, $b) = @_;
    die "Division by zero!\n" if $b == 0;
    return $a / $b;
}

my $result = eval { risky_divide(10, 0) };
if ($@) {
    print "caught via eval/\$\@: $@";     # $@ already ends in "\n" from our die message
} else {
    print "result: $result\n";
}

# eval also catches genuine runtime errors, not just explicit die calls.
eval { my @arr; $arr[0]->method_that_does_not_exist(); };
print "caught runtime error: ", ($@ ? "yes" : "no"), "\n";

# Perl 5.34+'s native try/catch (feature 'try') -- a real language feature,
# not a module, but still marked experimental by perl itself as of 5.38.2
# (hence `no warnings 'experimental::try'` above to silence the compile-time
# warning it would otherwise emit).
sub risky_divide2 {
    my ($a, $b) = @_;
    die "Division by zero (try/catch)!\n" if $b == 0;
    return $a / $b;
}

try {
    my $r = risky_divide2(10, 0);
    print "unreachable: $r\n";
} catch ($e) {
    print "caught via try/catch: $e";
}

try {
    my $r = risky_divide2(10, 2);
    print "try/catch success: $r\n";
} catch ($e) {
    print "unreachable catch: $e";
}

# die can also take a reference (an exception OBJECT), not just a string --
# the idiomatic way to build structured, catchable custom exceptions.
package MyError {
    sub new { my ($class, $msg) = @_; return bless { message => $msg }, $class; }
    sub message { return $_[0]->{message}; }
}

try {
    die MyError->new("structured failure");
} catch ($e) {
    if (ref($e) && $e->isa('MyError')) {
        print "caught structured exception: ", $e->message, "\n";
    }
}
