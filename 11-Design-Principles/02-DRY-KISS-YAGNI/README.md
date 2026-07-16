# 02 — DRY, KISS, and YAGNI

[Back to module overview](../README.md) | [Previous: SOLID Principles](../01-SOLID-Principles/README.md)

## Beginner: Three Principles, Three Real Bugs

These three principles are each demonstrated the same way as [SOLID](../01-SOLID-Principles/README.md): a real violation that produces a real, wrong, verified result, followed by a fix that makes the bug structurally impossible or simply removes the unnecessary complexity/unused code that caused it.

## DRY — Don't Repeat Yourself

**The same knowledge or logic should exist in exactly one place.**

The violation copy-pastes a "member discount" rule into two functions. Verified live, the two copies **drifted apart** — one still applies the original 10%, the other was edited to 15% without the change being made to the other copy:

```
Order total (member, $100 subtotal):   $90.00 (10% discount)
Invoice total (member, $100 subtotal): $85.00 (should ALSO be 10%, but copy #2 drifted to 15%!)
```

The fix extracts `memberDiscountRate()` into one shared method that both callers use — verified live, both totals are now correctly consistent (`$90.00` for both), and it is now structurally impossible for them to silently drift apart again, since there is only one place the rate is defined.

## KISS — Keep It Simple, Stupid

**Prefer the simplest solution that works; unnecessary cleverness hides bugs.**

The violation uses a "clever" bit-trick one-liner to check if a number is a power of two: `(n & (n - 1)) == 0`. Verified live, this is **actually wrong** for `n = 0`:

```
isPowerOfTwoViolation(0) = true  (0 is NOT a power of two!)
isPowerOfTwoViolation(8) = true  (correct, by luck of the bit trick)
```

The clever version happened to work for `8`, masking the fact that it was never actually correct for all inputs. The simple, fixed version explicitly checks `n <= 0` first — the exact edge case a straightforward reading of the problem naturally surfaces, but the "clever" bit-trick let a real bug hide in:

```
isPowerOfTwo(0) = false
isPowerOfTwo(8) = true
```

## YAGNI — You Aren't Gonna Need It

**Don't build functionality until it's actually needed.**

The violation adds a speculative `"EU_SPECULATIVE"` tax strategy "just in case," never actually requested or used. Verified live, this speculative, unused code path contains a **real, unnoticed bug** — it multiplies by `0.20` where it should have applied a `1 + rate` style calculation:

```
US tax on $100: $108.00 (correct)
EU_SPECULATIVE tax on $100: $20.00 (BUG: should probably be $120, not $20 -- nobody ever noticed, because nobody ever used it)
```

This is the real cost YAGNI warns about: unused speculative code isn't neutral — it's actively unverified, and bugs inside it can sit undetected indefinitely (as demonstrated here) simply because nothing ever exercises it. The fix keeps only the one actually-needed case, with nothing unverified sitting in the codebase.

## Detailed Example

See [Example.java](Example.java) — all three principles, each with a real, verified violation and fix.

## Run It

```bash
cd 11-Design-Principles/02-DRY-KISS-YAGNI
javac Example.java
java Example
```

## Expected Output

Three sections (DRY, KISS, YAGNI), each showing a real violation's incorrect output followed by the fixed version's correct output — including a genuinely drifted discount rate, a genuinely wrong power-of-two check for `n = 0`, and a genuinely buggy unused tax strategy.

## Common Mistakes

- Copy-pasting logic "just this once" — verified live in this lesson, even a simple percentage rule drifted into two different values across two copies within the same small example.
- Preferring "clever" code (bit tricks, dense one-liners) over obviously-correct code — verified live to hide a real edge-case bug (`n = 0`) that a straightforward version would have surfaced immediately.
- Building speculative flexibility "for the future" — verified live to introduce genuinely buggy, entirely unverified code, since nothing ever exercises a code path nobody actually uses yet.

## Best Practices

- Extract genuinely duplicated logic into one shared location as soon as a second copy appears — don't wait for a third.
- Favor obviously-correct code over clever code, especially in a codebase that will be maintained by people other than its original author.
- Build only what's needed for the current, real requirement; add flexibility when a second real use case actually appears, not speculatively in advance.

## Real-World Usage

DRY violations are a common source of production bugs where "the same rule" (a tax rate, a discount, a validation rule) is implemented in multiple places and quietly drifts apart over time, exactly as demonstrated here. YAGNI is one of the most frequently cited principles in code review for exactly the reason shown in this lesson: unused, speculative code is not free — it's a real liability that can hide real bugs indefinitely.

## Summary

- DRY: extracting duplicated logic into one place made a real, observed rate-drift bug structurally impossible.
- KISS: the simple, explicit version was correct where the "clever" one-liner silently failed on an edge case.
- YAGNI: unused, speculative code contained a genuine, unnoticed bug — building only what's actually needed avoids this entire class of risk.

## Key Terms

- **DRY (Don't Repeat Yourself)** — every piece of knowledge/logic should have a single, authoritative representation.
- **KISS (Keep It Simple, Stupid)** — prefer the simplest solution that correctly solves the problem.
- **YAGNI (You Aren't Gonna Need It)** — don't implement functionality until it's actually required.

## Interview Questions

1. **How was a DRY violation shown to cause an actual bug, rather than just "duplicate code smell"?**
   Two functions (`orderTotalViolation`, `invoiceTotalViolation`) each independently implemented the "member discount" rule as a literal, copy-pasted percentage. Verified live, one copy was later changed to `0.15` while the other remained at `0.10` — producing two different, inconsistent discounted totals ($90.00 vs. $85.00) for what should have been the exact same business rule applied to the exact same $100 subtotal. Extracting the rate into a single shared `memberDiscountRate()` method made both callers consistent again and eliminated the possibility of this drift recurring.

2. **Why does YAGNI's argument go beyond "don't waste time" — what did this lesson demonstrate as the real risk of speculative code?**
   Beyond wasted effort, speculative, unused code is never exercised by real usage, so bugs inside it can go completely unnoticed indefinitely. This was demonstrated concretely: a speculative `"EU_SPECULATIVE"` tax strategy, added "just in case" and never actually used, contained an actual calculation bug (`amount * 0.20` instead of an intended `amount * 1.20`-style calculation) that was never caught, specifically because no real code path ever called it — proof that unused code isn't a neutral, harmless placeholder, but an unverified liability.

## Recommended Next Lesson

[03 — Coupling and Cohesion](../03-Coupling-and-Cohesion/README.md)
