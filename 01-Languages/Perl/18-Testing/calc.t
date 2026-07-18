#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;   # confirmed bundled core module (`perl -MTest::More -e 1` succeeds)
use lib '.';
use Calc qw(add divide);

# Test::More/prove is Perl's de facto standard testing setup: each .t file
# is a runnable script, `prove` runs a whole directory of them and
# summarizes pass/fail across all.

is(add(2, 3), 5, 'add(2,3) is 5');
is(add(-1, 1), 0, 'add(-1,1) is 0');

is(divide(10, 2), 5, 'divide(10,2) is 5');

eval { divide(1, 0) };
like($@, qr/Division by zero/, 'divide by zero dies with expected message');

ok(add(2, 2) != 5, 'sanity: 2+2 is not 5');

done_testing();
