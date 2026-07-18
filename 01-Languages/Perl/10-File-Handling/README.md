# 10 — File Handling

[Back to course overview](../README.md) | [Previous: Error Handling](../09-Error-Handling/README.md)

## Learning Objectives

- Use `open`/`close` with lexical filehandles and the 3-argument form.
- Read a file line by line with `<$fh>`.
- Verify `JSON::PP` is bundled with this Perl install and use it for real encode/decode.

## Concept

`JSON::PP` availability was checked before writing this lesson:

```bash
$ perl -MJSON::PP -e "print 1"
```
Output (actual): `1` — confirmed bundled (JSON::PP has shipped in Perl core since 5.14).

See [`files.pl`](files.pl), run with `perl files.pl`. Output (actual):

```
read: line one
read: line two
read: line three
encoded: {"tags":["mathematician","programmer"],"year":1815,"name":"Ada Lovelace"}
decoded name: Ada Lovelace, year: 1815
cleaned up scratch_notes.txt
```

Notes:
- `open(my $out, '>', $tmpfile) or die "...: $!"` — always use the 3-argument form (mode as a separate argument) and a lexical filehandle (`my $fh`), never the old 2-argument/bareword-filehandle style.
- `while (my $line = <$in>)` reads one line at a time including the trailing newline, hence `chomp`.
- `encode_json`/`decode_json` round-trip a Perl hashref through JSON text. Note the key order in the encoded output (`tags`, `year`, `name`) does **not** match insertion order — `JSON::PP` does not guarantee key ordering by default, consistent with hashes being unordered.
- `unlink $tmpfile` deletes the scratch file created by this script — verified the file no longer exists after the run (`ls` on it afterward genuinely fails with "No such file or directory").

## Common beginner mistakes

- Using the old `open(FH, ">file.txt")` 2-arg bareword form — no error checking on mode, and global namespace pollution.
- Forgetting to `close` filehandles explicitly (though Perl closes them on scope exit for lexical `$fh`, explicit `close` catches write errors like a full disk).
- Assuming JSON key order round-trips — it does not by default.

## Best practices

- Always use 3-arg `open` with lexical filehandles and check the return value with `or die "$!"`.
- Prefer `JSON::PP` (or `JSON::XS` if installed) over hand-rolled string parsing for structured data.
