# 18 — Testing

[Back to course overview](../README.md) | [Previous: API Integration](../17-API-Integration/README.md)

## Learning Objectives

- Write real `Test::More`-based test files (`.t`) against a real module.
- Understand TAP (Test Anything Protocol) output.
- Attempt `prove` and honestly document what happened when it did not work in this environment.

## Environment check — verified live

```bash
$ perl -MTest::More -e "print 1"
```
Output (actual): `1` — `Test::More` is core, confirmed present.

## Concept

[`lib/Calc.pm`](lib/Calc.pm) — a small module under test:

```perl
package Calc;
sub add { my ($a, $b) = @_; return $a + $b; }
sub divide {
    my ($a, $b) = @_;
    die "division by zero\n" if $b == 0;
    return $a / $b;
}
```

[`t/calc.t`](t/calc.t) — real `Test::More` assertions:

```perl
use Test::More;
use Calc qw(add divide);

is(add(2, 3), 5, 'add(2,3) == 5');
is(add(-1, 1), 0, 'add(-1,1) == 0');
is(divide(10, 2), 5, 'divide(10,2) == 5');
eval { divide(1, 0) };
like($@, qr/division by zero/, 'divide by zero dies with expected message');

done_testing();
```

### `prove` — attempted, honestly documented as broken in this environment

```bash
$ prove -v t/calc.t
```
Output (actual):
```
Can't locate TAP/Harness/Env.pm in @INC (you may need to install the TAP::Harness::Env module) (@INC entries checked: /usr/lib/perl5/site_perl /usr/share/perl5/site_perl /usr/lib/perl5/vendor_perl /usr/share/perl5/vendor_perl /usr/lib/perl5/core_perl /usr/share/perl5/core_perl) at /usr/share/perl5/core_perl/App/Prove.pm line 6.
BEGIN failed--compilation aborted at /usr/share/perl5/core_perl/App/Prove.pm line 6.
Compilation failed in require at /usr/bin/core_perl/prove line 9.
BEGIN failed--compilation aborted at /usr/bin/core_perl/prove line 9.
```

This msys2 install's `prove` (at `/usr/bin/core_perl/prove`) is broken by a missing dependency (`TAP::Harness::Env`) in its own core distribution — a real, environment-specific gap, not something faked around. `prove` itself is a thin wrapper around `TAP::Harness`; when its own dependency is missing, it cannot run at all, regardless of how correct the test file is.

### The working alternative — running the `.t` file directly with `perl`

`.t` files are ordinary Perl scripts; `Test::More`'s `is`/`like`/`done_testing` print raw TAP to stdout with no harness required. Running the exact same test file directly:

```bash
$ perl -Ilib t/calc.t
```
Output (actual):
```
ok 1 - add(2,3) == 5
ok 2 - add(-1,1) == 0
ok 3 - divide(10,2) == 5
ok 4 - divide by zero dies with expected message
1..4
```

This is real TAP output (`ok N - description`, then the `1..4` plan line from `done_testing()`), produced by genuinely running all four assertions, including one that provokes `divide`'s `die` and asserts on the caught `$@` message with `like(..., qr/.../)`. All four passed.

## Common beginner mistakes

- Assuming `prove` is always available just because `Test::More` is — as demonstrated, they can be decoupled in an install with a broken/incomplete core distribution.
- Forgetting `done_testing()` (or a `plan tests => N;` at the top) — `Test::More` needs to know when the test file is complete to emit a valid TAP plan line.
- Testing `$@` immediately after `eval` without also asserting a specific message pattern — an empty/wrong exception can slip through a bare "did it die" check.

## Best practices

- Run `.t` files directly with `perl` (`perl -Ilib t/foo.t`) as a working fallback whenever `prove` is unavailable or broken, since `Test::More` output is self-contained TAP.
- Use `like($@, qr/.../)` rather than `ok($@)` alone, to assert on the actual error content, not just "something died."
