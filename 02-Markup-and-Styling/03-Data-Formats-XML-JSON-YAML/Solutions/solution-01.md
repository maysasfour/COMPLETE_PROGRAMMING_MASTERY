# Solution 01 — Fix the Norway Problem

[Back to lesson](../README.md) | [Exercise](../Exercises/exercise-01.md)

Runnable code lives in `solution-01.py`. Verified output:

```
=== Checking catalog.yaml's shipsFrom fields ===
Caught the real bug: Field 'catalog.books.0.shipsFrom' was expected to be a string but YAML parsed it as bool (False) -- likely an unquoted value that collided with YAML's implicit boolean/null conversion (the 'Norway problem').
```

## Explanation

`_resolve_path` walks a dotted path (splitting on `.`, treating purely-numeric segments as list indices) through the loaded YAML structure. `safe_load_with_string_check` then checks each expected-string field's actual Python type after parsing, raising a clear, specific `ValueError` the moment one comes back as something other than `str` — turning a silent data-corruption bug into an immediate, loud failure with the exact field path named.

## Reflection Answers

1. **Why only unquoted values are affected, and why quoting fixes it.** YAML's implicit-typing rules only apply to *plain scalars* (unquoted values) — the parser has to guess a type from the bare text, and its guessing rules (YAML 1.1) happen to include `no`/`NO`/`No` among the recognized boolean spellings. A quoted value (`"NO"`) is explicitly, unambiguously a string in YAML's grammar — quoting removes all ambiguity, so no implicit-type guessing ever applies to it.

2. **Why PyYAML hasn't switched to YAML 1.2 by default.** PyYAML's `safe_load`/`full_load` still implement YAML 1.1 for backward compatibility — countless existing YAML files and tools depend on 1.1's specific (if surprising) implicit-conversion behavior, and silently changing the default parsing rules out from under them could break configs that currently work by relying on `yes`/`no` being parsed as booleans on purpose. (The newer `ruamel.yaml` library supports YAML 1.2 parsing and narrows the implicit-boolean set considerably, specifically to avoid this class of bug — but it isn't a drop-in default replacement for PyYAML across the wider Python ecosystem.)

3. **Other real-world data at risk.** Any short code or identifier that happens to collide with YAML 1.1's implicit-boolean word list — besides Norway's `NO`, this includes `ON` (a valid abbreviation for the Canadian province Ontario), any postal/region code spelled `Y`, `N`, `YES`, or `TRUE` in any casing, and single-letter survey or flag responses (`"y"`/`"n"` recorded as literal text) if left unquoted. Anywhere a real-world short code or free-text label happens to look like one of `y|Y|yes|Yes|YES|n|N|no|No|NO|true|True|TRUE|false|False|FALSE|on|On|ON|off|Off|OFF` is a real risk under YAML 1.1's implicit typing.

## Common Pitfalls

- Assuming a YAML value's Python type without checking it after parsing — as demonstrated directly, the *exact same word* (`NO`) parses to two completely different types depending purely on whether it was quoted in the source file, with no warning from the parser either way.
- Fixing this by manually re-quoting every risky value in a large existing YAML file without also adding an automated check like this exercise's — a config file with hundreds of country/state/status codes is exactly where a human is most likely to miss one.
- Assuming this problem is specific to PyYAML/Python — it's a property of the YAML 1.1 specification's implicit-typing rules themselves, and affects any YAML 1.1-compliant parser in any language.
