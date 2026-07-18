# Perl Cheat Sheet

## Sigils

```perl
my $scalar = 1;     # single value
my @array  = (1,2); # list
my %hash   = (a=>1);# key/value
```
`$x`, `@x`, `%x` are three *independent* variables (verified in [02-Syntax](02-Syntax/README.md)).

## Strict/Warnings (always)

```perl
use strict;
use warnings;
```

## Variables

```perl
my $x = 5;        # lexical (file/block scoped)
our $g = 5;        # package global
local $/ = undef;  # dynamically-scoped save/restore
```

## Operators

| Numeric | String | Meaning |
|---|---|---|
| `==` `!=` | `eq` `ne` | equality |
| `<` `>` `<=` `>=` | `lt` `gt` `le` `ge` | ordering |
| `<=>` | `cmp` | 3-way compare (for `sort`) |
| `.` | — | string concat |
| `x` | — | string/list repeat |

## Control Flow

```perl
if ($x) { ... } elsif ($y) { ... } else { ... }
unless ($x) { ... }              # if !$x
print "hi\n" if $x;              # postfix
print "hi\n" unless $x;
for my $i (0..4) { ... }
foreach my $item (@list) { ... }
while ($cond) { ... }
until ($cond) { ... }             # while !$cond
```

## Functions

```perl
sub add { my ($a, $b) = @_; return $a + $b; }
my @r = add(1,2);    # list context
my $r = add(1,2);    # scalar context
```

## Collections

```perl
push @a, $x;  pop @a;  shift @a;  unshift @a, $x;
my @slice = @a[1..3];
my @m = map { $_ * 2 } @a;
my @g = grep { $_ > 0 } @a;
my @s = sort { $a <=> $b } @a;   # numeric
my @s2 = sort { $a cmp $b } @a;  # string
keys %h; values %h; exists $h{k}; delete $h{k};
```

## Strings & Regex

```perl
"Hello $name\n";      # double: interpolates
'Hello $name\n';       # single: literal
$s =~ /pattern/;
$s =~ s/old/new/;
$s =~ s/old/new/g;     # global
```

## Error Handling

```perl
eval { die "boom\n" };
print $@ if $@;

use feature 'try';
no warnings 'experimental::try';
try { risky() } catch ($e) { warn "caught: $e" }
```

## File I/O

```perl
open(my $fh, '<', 'file.txt') or die "$!";
while (my $line = <$fh>) { ... }
close $fh;
```

## OOP (bless)

```perl
package Point;
sub new { my ($class,%a) = @_; return bless { x=>$a{x}, y=>$a{y} }, $class; }
sub show { my $self = shift; print "($self->{x},$self->{y})\n"; }
```

## OOP (experimental `class`, 5.38+)

```perl
use feature 'class';
no warnings 'experimental::class';
class Point {
    field $x :param = 0;
    field $y :param = 0;
    method show { print "($x,$y)\n"; }
}
```

## Modules

```perl
package My::Module;
use Exporter 'import';
our @EXPORT_OK = ('foo');
1;   # required truthy final value

# caller:
use My::Module qw(foo);
```

## Testing

```perl
use Test::More;
is($got, $expected, 'description');
ok($bool, 'description');
done_testing();
```
Run with: `prove -v t/*.t`
