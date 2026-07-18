use strict;
use warnings;
use Test::More;
use lib '../lib', 'lib';
use Calc qw(add divide);

is(add(2, 3), 5, 'add(2,3) == 5');
is(add(-1, 1), 0, 'add(-1,1) == 0');
is(divide(10, 2), 5, 'divide(10,2) == 5');
eval { divide(1, 0) };
like($@, qr/division by zero/, 'divide by zero dies with expected message');

done_testing();
