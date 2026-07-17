# 03 — Data Formats: XML, JSON, and YAML

[Back to module overview](../README.md) | [Previous: CSS3](../02-CSS3/README.md)

## Learning Objectives

- Read and write the same structured data in XML, JSON, and YAML, and recognize each format's distinct syntax.
- Understand what each format does and doesn't provide natively (types, comments, references) and why that shapes where each is actually used in practice.
- Parse all three with real Python code (`xml.etree.ElementTree`, the built-in `json` module, and PyYAML) rather than treating them as interchangeable.
- Recognize and defend against a real, well-known YAML parsing bug (the "Norway problem") rather than being surprised by it in production.

## Concept: Three Formats, Three Different Design Goals

- **XML** (Extensible Markup Language) is the oldest of the three, tag-based like HTML, and was designed for documents and configuration where structure, attributes, namespaces, and schema validation (DTD/XSD) matter. It has **no native types** — every value is text until a consumer decides how to interpret it (`"true"` is just the three characters `t`, `r`, `u`, `e` until code checks for that exact string).
- **JSON** (JavaScript Object Notation) was designed to be a minimal, directly-executable-as-JavaScript data interchange format. It has native types (string, number, boolean, `null`, array, object) but **no comments** — a deliberate omission by its creator, to keep JSON strictly data rather than semi-executable/annotated config.
- **YAML** (YAML Ain't Markup Language) was designed to be human-writable/readable configuration, is a superset-ish of JSON syntax (valid JSON is close to valid YAML), supports comments, and has considerably more implicit typing magic than JSON — which is exactly the source of this lesson's featured real bug.

## Detailed Example: The Same Catalog, Three Ways

[`catalog.xml`](catalog.xml), [`catalog.json`](catalog.json), and [`catalog.yaml`](catalog.yaml) all model the identical two-book catalog. `implementation.py` parses all three and confirms they agree on titles/authors — but XML's `inStock="true"`/`"false"` attributes come back as **plain strings**, requiring an explicit `== "true"` conversion, unlike JSON's and YAML's native booleans.

## A Real, Famous Bug: The "Norway Problem"

`catalog.yaml` deliberately includes `shipsFrom: NO` (unquoted) on one book and `shipsFrom: "NO"` (quoted) on the other — both intended as Norway's two-letter ISO country code. Parsed live:

```
unquoted NO parsed as: False (type: bool)
quoted "NO" parsed as: 'NO' (type: str)
```

This is not a contrived example — it's a real, well-documented category of bug informally called "the Norway problem" in the YAML community. YAML 1.1 (which PyYAML's default loader implements) treats a specific list of bare words — `y|Y|yes|Yes|YES|n|N|no|No|NO|true|True|TRUE|false|False|FALSE|on|On|ON|off|Off|OFF` — as implicit booleans when unquoted. A two-letter country code, a feature flag literally named "on"/"off", or a single-letter survey response can all silently become the wrong type with zero warning from the parser. The fix is always the same: quote any value that could plausibly collide with that word list, and — better — validate the *types* you actually got back, which is exactly what this lesson's exercise builds.

## How to Run

```bash
cd 02-Markup-and-Styling/03-Data-Formats-XML-JSON-YAML
python implementation.py
```

## Verified Output

```
=== Parsing the SAME catalog data from three different formats ===
XML  parsed titles: ['The Pragmatic Programmer', 'Clean Code']
JSON parsed titles: ['The Pragmatic Programmer', 'Clean Code']
YAML parsed titles: ['The Pragmatic Programmer', 'Clean Code']

=== XML has NO native boolean/number types -- everything is text until YOU convert it ===
XML  inStock values (converted manually): [True, False]
JSON inStock values (native JSON booleans): [True, False]
Both agree once XML's text is explicitly converted: True

=== A real, famous YAML gotcha: the 'Norway problem' ===
unquoted NO parsed as: False (type: bool)
quoted "NO" parsed as: 'NO' (type: str)

=== A real XML parse error, on purpose ===
ET.fromstring on malformed XML raised a real ParseError: mismatched tag: line 1, column 29
```

## Common Mistakes

- Assuming XML attributes/text are already the "right" type — they are always strings; converting `"true"`/`"42"` to a real bool/int is always the consuming code's own responsibility.
- Leaving country/state codes, feature flags, or single-letter responses unquoted in YAML — as demonstrated directly, this can silently produce the wrong type with no parser warning at all.
- Adding comments to a JSON file and being surprised when a strict parser rejects them — JSON deliberately has no comment syntax; YAML or a JSON variant (JSON5, JSONC) exist specifically for cases where comments are wanted.
- Treating JSON/YAML/XML as interchangeable without considering their actual differences (schema validation and namespaces for XML; strict portability and native web-JS integration for JSON; human-editability and comments for YAML).

## Best Practices

- Always validate the *type* of a value parsed from YAML if there's any chance it could collide with the implicit-boolean/null word list — don't just trust that a value "looks like" a string in the source file.
- Use XML when schema validation (XSD/DTD), namespaces, or document-oriented structure genuinely matter — not as a default choice for simple data interchange, where JSON is almost always simpler.
- Prefer JSON for machine-to-machine data interchange (APIs, data interchange between services) where its lack of comments is a non-issue and its strict/simple/portable nature is a real advantage.
- Prefer YAML for human-edited configuration (CI/CD pipelines, Kubernetes manifests, application config) where comments and readability genuinely matter more than strictness — while being aware of, and guarding against, its implicit-typing surprises.

## Summary

- XML has no native types (everything is text, converted by the consumer); JSON has native types but no comments; YAML has native types, comments, and considerably more (occasionally surprising) implicit-typing behavior.
- The "Norway problem" is a real, documented YAML 1.1 parsing gotcha where unquoted values like `NO`, `yes`, `on` silently become booleans instead of the intended string — reproduced directly in this lesson, not just described.
- Quoting a value removes all implicit-type ambiguity in YAML; validating parsed types explicitly (this lesson's exercise) catches the cases a human might miss quoting.

## Key Terms

- **Schema validation (XSD/DTD)** — XML-specific mechanisms for formally validating a document's structure against a defined schema; JSON and YAML have their own separate schema-validation ecosystems (JSON Schema) rather than a built-in equivalent.
- **Implicit typing** — a parser inferring a value's type from its bare (unquoted) text, rather than requiring an explicit type marker; the source of YAML's Norway problem.
- **Plain scalar** — a YAML term for an unquoted value, subject to implicit-typing rules; a quoted value is never subject to them.

## Interview Questions

1. **What is a concrete, real difference between XML and JSON beyond "XML uses tags and JSON uses braces"?**
   XML has no native data types at all (every value is text until explicitly converted by consuming code) and supports schema validation (XSD/DTD) and namespaces natively; JSON has native types (string/number/boolean/null/array/object) built into its own grammar, but no native schema-validation mechanism of its own (JSON Schema is a separate, additional specification) and no comment syntax.

2. **Explain the "Norway problem" and why it happens.**
   YAML 1.1 (the version most common YAML libraries, including PyYAML's default loader, implement) treats certain unquoted bare words — including `no`, `NO`, `No` — as implicit booleans. Norway's ISO country code is `NO`, so an unquoted `NO` intended as a country code silently parses as the boolean `False` instead, with no warning from the parser. Quoting it (`"NO"`) removes the ambiguity entirely.

3. **Why does JSON deliberately have no comment syntax, while YAML does?**
   JSON was designed to be a minimal, strictly-data interchange format, directly parseable as a JavaScript object literal — comments would add parsing complexity and ambiguity (e.g., is a comment part of a string value or not) for a format meant to be machine-generated and machine-consumed far more often than hand-edited. YAML was specifically designed for human-authored configuration, where comments genuinely aid readability and maintainability.

4. **If you had a config file with hundreds of entries, some of which might accidentally collide with YAML's implicit-boolean words, how would you defend against silent bugs like the Norway problem at scale, rather than manually reviewing every value?**
   Validate the *parsed types* of fields expected to be strings immediately after loading (this lesson's exercise's approach) — raising an explicit, clear error the moment a field comes back as the wrong type, rather than trusting that every risky value was correctly quoted by whoever wrote the file. This turns a silent, hard-to-notice data-corruption bug into an immediate, loud failure pointing at the exact field.

## Exercises

See [Exercises/](Exercises/).

## Solutions

See [Solutions/](Solutions/).

## Suggested Next Lesson

[04 — Markdown](../04-Markdown/README.md)
