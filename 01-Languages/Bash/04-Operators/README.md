# 04 — Operators

[Back to Bash course](../README.md)

## Beginner: Arithmetic Requires `$(( ))` or `let` — Verified Live

Coming from almost any other language, the instinct is to write `a + b` and expect addition. In Bash that is wrong:

```bash
$ a=5; b=3
$ echo "$a + $b"
5 + 3
```

`"$a + $b"` inside a plain double-quoted string just performs variable substitution and leaves the literal `+` character alone — it produces the **string** `"5 + 3"`, not the number 8. Real arithmetic needs an explicit arithmetic context:

```bash
$ echo $((a + b))
8
$ echo $(( a * b ))
15
$ let "c = a + b"; echo "$c"
8
```

`$(( ))` (an arithmetic expansion) and `let` both evaluate their contents as a math expression; inside `$(( ))` you don't even need the `$` prefix on variable names (`a + b`, not `$a + $b`), though `$a + $b` also works there.

## String Comparison vs. Numeric Comparison — Verified Live

This is one of the most common real bugs for newcomers: `=`/`==` compare *strings*, while `-eq`/`-lt`/`-gt`/etc. compare *numbers*. They are not interchangeable, and using the wrong one gives a wrong-but-not-obviously-wrong answer:

```bash
$ x=10; y=9
$ if [ "$x" -gt "$y" ]; then echo "numeric: x>y"; fi
numeric: x>y

$ if [ "$x" \> "$y" ]; then echo "string: x>y (wrong! lexical)"; else echo "string: x not > y lexically"; fi
string: x not > y lexically

$ if [ "$x" = "$y" ]; then echo "eq"; else echo "not string-eq"; fi
not string-eq
```

`"10" -gt "9"` is numerically true (10 > 9). But `"10" \> "9"` — the **string** comparison operator inside `[ ]` — is false, because lexicographically the character `'1'` sorts before `'9'`, so the string `"10"` sorts *before* the string `"9"`. This is a genuine, reproducible trap: a version-number or numeric-ID comparison written with the wrong operator will silently misbehave once values cross a digit-count boundary (e.g., comparing `"9"` and `"10"` as strings gives the opposite answer from comparing them as numbers).

```bash
$ [[ "10" > "9" ]] && echo "'10' > '9' lexically? yes" || echo "'10' > '9' lexically? no"
'10' > '9' lexically? no
```

## Comparison Operator Reference

| Meaning | String operator | Numeric operator |
|---------|------------------|-------------------|
| equal | `=` or `==` | `-eq` |
| not equal | `!=` | `-ne` |
| greater than | `\>` (in `[ ]`) or `>` (in `[[ ]]`) | `-gt` |
| less than | `\<` (in `[ ]`) or `<` (in `[[ ]]`) | `-lt` |
| greater or equal | — (compose with `!` `<`) | `-ge` |
| less or equal | — | `-le` |

## Common Beginner Mistakes

- Writing `if [ $a > $b ]` expecting numeric comparison — `>` inside `[ ]` is actually **output redirection** to a file named `$b`, not a comparison at all (a silent, dangerous bug: it creates/truncates a file).
- Using `=` to compare numbers that happen to have leading zeros or different formatting (`"007"` vs `"7"` as strings are unequal, but numerically equal).
- Forgetting that `$(( ))` needs no `$` on operands, while everywhere else variables need `$`.

## Best Practices

- Use `$(( ))` for all arithmetic; never rely on bare `+`/`-` outside an arithmetic context.
- Use `-eq`/`-lt`/`-gt`/etc. exclusively for numbers; use `=`/`!=` exclusively for strings.
- Never use bare `>`/`<` inside single-bracket `[ ]` for comparison — it's redirection there. Inside `[[ ]]`, `>`/`<` are safe string comparisons.

## Interview Questions

1. Why does `echo "$a + $b"` not perform addition, and what would you write instead?
2. Why is `[ $a > $b ]` dangerous even though it "looks like" a comparison?
3. Give a concrete pair of values where string comparison and numeric comparison of the same two variables disagree.
