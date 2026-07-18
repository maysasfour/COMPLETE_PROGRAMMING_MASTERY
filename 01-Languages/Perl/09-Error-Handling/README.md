# 09 — Error Handling

[Back to course overview](../README.md) | [Previous: Strings](../08-Strings/README.md)

## Learning Objectives

- Use the traditional `eval { } ; $@` mechanism.
- Verify live whether this 5.38.2 install supports the native `try`/`catch` feature (5.34+), and use it if available.

## Concept

### Traditional: `eval`/`die`/`$@`

`die` raises an exception (a string or object); `eval { BLOCK }` catches it, and `$@` holds the error afterward (empty string if no error occurred).

### Modern: native `try`/`catch` — verified live

This Perl 5.38.2 (msys build) **does** support `use feature 'try'`, confirmed by actually running it. See [`errors.pl`](errors.pl), run with `perl errors.pl`. Output (actual):

```
traditional caught: cannot divide by zero
try/catch caught: negative not allowed
try/catch success: 4
```

Relevant code:

```perl
use feature 'try';
no warnings 'experimental::try';

try {
    my $r = might_fail(-5);
} catch ($e) {
    print "try/catch caught: $e";
}
```

Both mechanisms coexist in this version — `try`/`catch` needs `no warnings 'experimental::try'` because, as of 5.38, the feature is still marked experimental (it was introduced in 5.34 and had not yet been stabilized as of this Perl build). No warning noise appeared in stdout/stderr during the run above because the `no warnings` pragma suppressed it, confirming the module is genuinely present and working rather than silently no-op'ing.

## Common beginner mistakes

- Forgetting the trailing `\n` on `die "message\n"` — without it, Perl appends `" at FILE line N."` to the message, which is often *not* what you want for user-facing errors (though it's useful for debugging).
- Checking `if ($@)` incorrectly after an `eval` that might legitimately return a false-but-defined value — always check `$@` immediately after `eval`, before any other code that might reset it.
- Using `try`/`catch` without `no warnings 'experimental::try'` — the feature works but emits warnings.

## Best practices

- Prefer `try`/`catch` for new code targeting Perl 5.34+ — clearer block structure than `eval`/`$@`.
- Still know `eval`/`die`/`$@` — it's what you'll see in the vast majority of existing/legacy Perl code and in any environment predating 5.34.
- Always end `die` messages with `\n` unless you deliberately want the file/line suffix.
