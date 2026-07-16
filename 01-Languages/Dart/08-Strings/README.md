# 08 — Strings

[Back to course overview](../README.md) | [Previous: Collections](../07-Collections/README.md)

## Learning Objectives

- Use core string methods and multi-line (triple-quoted) strings.
- Understand `String.length` counts UTF-16 code units — matching Java/JavaScript's approach (both covered earlier in this repository), genuinely different from Swift's grapheme-cluster-based `.count` (also covered earlier), verified live with a multi-scalar emoji.

## Prerequisites

[07-Collections](../07-Collections/README.md)

## Concept

Dart strings are UTF-16 sequences internally (the same representation JavaScript and Java use, both covered elsewhere in this repository), and `String.length` counts UTF-16 **code units**, not Unicode scalars and not grapheme clusters (the perceptually-correct "characters" Swift's `.count` measures, covered in this repository's Swift course). This means a character requiring a UTF-16 surrogate pair (two code units) — common for emoji and characters outside the Basic Multilingual Plane — inflates `.length` beyond the character's actual scalar or perceptual count.

## `.length` Counts UTF-16 Code Units, Verified Live

```dart
var flag = '🇺🇸'; // TWO Unicode scalars, each needing a UTF-16 surrogate pair
print(flag.length);           // 4 -- UTF-16 code units (2 scalars x 2 units each)
print(flag.runes.length);     // 2 -- actual Unicode SCALAR count, via .runes

var accented = 'café'; // é is within the Basic Multilingual Plane -- one UTF-16 unit
print(accented.length); // 4 -- matches character count here, since no surrogate pairs are involved
```

Verified live: the flag emoji (built from two Unicode scalars, each requiring a UTF-16 surrogate pair) reports `.length` as `4`, while `.runes.length` (the actual Unicode scalar count) correctly reports `2`. This mirrors Java's `.length()` and JavaScript's `.length` (both UTF-16-code-unit-based, covered in this repository's Java and JavaScript courses) rather than Swift's `.count` (grapheme-cluster-based, treating even the more complex family emoji as a single "character," covered in the Swift course).

## Iterating by Rune (Unicode Scalar)

```dart
for (var rune in 'café'.runes) {
  print(String.fromCharCode(rune)); // iterates by actual Unicode scalar, not UTF-16 code unit
}
```

`.runes` provides an iterable of Unicode scalar values (code points), correctly handling surrogate pairs as single runes — the Dart equivalent of iterating "by rune" in Go or "by char" in Rust (both covered earlier in this repository), as opposed to iterating raw UTF-16 code units directly.

## Core String Methods and Multi-Line Strings

```dart
s.toUpperCase(); s.toLowerCase(); s.replaceAll('a', 'b'); s.substring(7, 12);
s.contains('x'); s.startsWith('x'); s.split(',');

var raw = '''
Line one
Line two
''';
```

## Detailed Example

See [example.dart](example.dart) — string interpolation, core string methods, a triple-quoted multi-line string, the live-verified `.length`-vs-`.runes.length` distinction with a multi-scalar emoji, and rune-based iteration.

## Run It

```bash
cd 01-Languages/Dart/08-Strings
dart run example.dart
```

## Expected Output

Running `dart run example.dart` prints the interpolated string, the uppercase/lowercase/replace/substring/contains/startsWith/split results, the multi-line string (with the escaped `\\n` printing literally), `flag.length: 4` followed by `flag.runes.length: 2`, `accented.length: 4`, and each rune of `café` iterated individually — all confirmed by actual execution.

## Common Mistakes

- Assuming `String.length` gives a perceptually-correct "character count" the way Swift's `.count` does — it doesn't; Dart's `.length` counts UTF-16 code units, verified live to report `4` for a 2-scalar emoji, not `1` or `2`.
- Using `.length` to truncate or slice a string containing characters outside the Basic Multilingual Plane — this can silently split a surrogate pair in half, producing invalid/corrupted output, since `.length`-based indexing operates at the code-unit level, not the scalar or grapheme level.
- Forgetting `.runes` (not raw string indexing) is needed for genuinely Unicode-scalar-aware iteration.

## Best Practices

- Use `.runes` (or the `characters` package from pub.dev, which provides grapheme-cluster-aware operations similar to Swift's built-in behavior) when genuine Unicode correctness matters, rather than relying on `.length` for user-facing character counts.
- Be aware that `.length`-based string slicing can corrupt multi-code-unit characters if not handled carefully, especially for user-generated content that might include emoji or characters outside the BMP.

## Real-World Usage

The UTF-16-code-unit-vs-Unicode-scalar-vs-grapheme-cluster distinction matters directly for any Dart/Flutter app handling international text or emoji — Flutter's own text-handling widgets and the `characters` package exist specifically to provide grapheme-cluster-aware operations where `.length`'s code-unit-based counting would otherwise misbehave for complex characters, mirroring the same category of concern covered in this repository's Go, Java, JavaScript, PHP, and Swift courses (each with its own specific counting behavior).

## Summary

- Dart's `String.length` counts UTF-16 code units, matching Java/JavaScript's approach, genuinely different from Swift's grapheme-cluster-based `.count` — verified live with a multi-scalar emoji reporting `.length: 4` but `.runes.length: 2`.
- `.runes` provides Unicode-scalar-aware iteration and counting, the more correct choice for genuinely international or emoji-containing text.

## Key Terms

- **UTF-16 code unit** — the 16-bit unit Dart's `.length` counts; some characters require two code units (a surrogate pair).
- **`.runes`** — an iterable of a Dart string's actual Unicode scalar values (code points), correctly handling surrogate pairs as single runes.

## Interview Questions

1. **Why did a single emoji character report `String.length` as `4` in this lesson, and what does `.runes.length` report instead?**
   The specific emoji used (a flag, built from two Unicode "regional indicator" scalars) requires a UTF-16 surrogate pair (two 16-bit code units) to represent *each* of its two scalars — so its total UTF-16 code unit count is 4, which is exactly what `.length` reported, verified live. `.runes.length` instead counts actual Unicode scalar values (code points), correctly treating each surrogate pair as one scalar, reporting `2` for this same emoji — closer to (though not identical to) a perceptual "character count," since some emoji (like complex, multi-scalar combined characters) still count as multiple runes even though they display as one visual glyph, unlike Swift's `.count` (covered in this repository's Swift course), which counts grapheme clusters and would report such cases as a single unit.

2. **How does Dart's string-length behavior compare to Java's and JavaScript's, both covered elsewhere in this repository?**
   Dart, Java, and JavaScript all represent strings internally as UTF-16 code unit sequences, and all three languages' primary length property/method (`.length`, `.length()`, `.length` respectively) counts UTF-16 code units — meaning all three would report the same inflated count for a character requiring a surrogate pair. This is a shared characteristic across these three languages, contrasted with Go and Rust (which measure byte length by default, requiring explicit rune/char iteration for character-aware counting) and Swift (which measures grapheme clusters directly via `.count`, the strongest built-in correctness guarantee among all the languages covered in this repository).

## Recommended Next Lesson

[09 — Error Handling](../09-Error-Handling/README.md)
