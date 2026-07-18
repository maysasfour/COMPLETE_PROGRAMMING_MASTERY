# 19 — Best Practices

[Back to course overview](../README.md) | [Previous: Testing](../18-Testing/README.md)

## Learning Objectives

- Always use `strict`/`warnings`.
- Recognize "write-only Perl" (dense, unchecked, cryptic code) and how to fix it.
- See a real anti-pattern and its fix, both actually run, with genuinely different behavior on a real error.

## Anti-pattern — run for real

[`antipattern.pl`](antipattern.pl):

```perl
# no strict/warnings, cryptic names, no error checking
$n = 5; $r = 1; for ($i=1;$i<=$n;$i++){$r*=$i;}
print "$r\n";

open(F, "does_not_exist_at_all.txt");
print "F opened (but did it really succeed?)\n";
while (<F>) { print; }
close(F);
print "done, silently\n";
```

Run with `perl antipattern.pl`. Output (actual):

```
120
F opened (but did it really succeed?)
done, silently
```

The factorial computes correctly (`120`), but the real problem is the `open` call: `does_not_exist_at_all.txt` genuinely does not exist, `open` genuinely fails, and the script **never notices** — no `strict`/`warnings`, no `or die`, so it silently proceeds straight past a failed file open to `"done, silently"` as if nothing went wrong. This is a real, reproduced example of "write-only Perl": terse, unchecked, and dangerously quiet on failure.

## Fixed version — run for real

[`fixed.pl`](fixed.pl):

```perl
use strict;
use warnings;

sub factorial {
    my ($n) = @_;
    my $result = 1;
    $result *= $_ for (1..$n);
    return $result;
}
print factorial(5), "\n";

open(my $fh, '<', 'does_not_exist_at_all.txt') or do {
    print "correctly detected open failure: $!\n";
};
```

Run with `perl fixed.pl`. Output (actual):

```
120
correctly detected open failure: No such file or directory
```

Same factorial result (`120`), but the exact same missing-file condition is now **caught and reported** (`No such file or directory`, Perl's real `$!` errno string) instead of being silently swallowed — the one-line change (`or die`/`or do { ... }` after `open`, plus 3-arg `open` with a lexical filehandle) is the entire difference between a script that lies about success and one that doesn't.

## Common beginner mistakes

- Treating `strict`/`warnings` as "training wheels to remove once experienced" — they catch entire classes of real bugs (see the `open` failure above) regardless of skill level.
- Checking `open`'s return value with `or print "warning"` but continuing execution anyway as if the filehandle were valid — always `die` or otherwise abort the dependent logic path.
- Dense one-liner style (`$n=5;$r=1;for(...){...}`) mistaken for "efficient" — it's identical performance to a spaced-out version and strictly worse for maintenance.

## Best practices

- `use strict; use warnings;` in every file, no exceptions.
- Check every `open`/`system`/external-command return value; fail loudly (`die`) rather than silently continuing.
- Favor named subs and named lexicals over terse one-liners once logic exceeds a single trivial expression.
