# 16 — Database Access

[Back to course overview](../README.md) | [Previous: Modules](../15-Modules/README.md)

## Learning Objectives

- Verify module availability before writing lesson content, rather than assuming.
- Understand the `DBI`/`DBD::*` architecture conceptually, honestly documented as unavailable in this specific environment.

## Environment check — verified live

```bash
$ perl -MDBI -e "print 1"
```
Output (actual):
```
Can't locate DBI.pm in @INC (you may need to install the DBI module) (@INC entries checked: /usr/lib/perl5/site_perl /usr/share/perl5/site_perl /usr/lib/perl5/vendor_perl /usr/share/perl5/vendor_perl /usr/lib/perl5/core_perl /usr/share/perl5/core_perl).
BEGIN failed--compilation aborted.
```

```bash
$ perl -MDBD::SQLite -e "print 1"
```
Output (actual):
```
Can't locate DBD/SQLite.pm in @INC (you may need to install the DBD::SQLite module) (@INC entries checked: /usr/lib/perl5/site_perl /usr/share/perl5/site_perl /usr/lib/perl5/vendor_perl /usr/share/perl5/vendor_perl /usr/lib/perl5/core_perl /usr/share/perl5/core_perl).
BEGIN failed--compilation aborted.
```

**Neither `DBI` nor `DBD::SQLite` is installed** in this Perl 5.38.2 msys2 build. Per this course's policy (see [01-Setup](../01-Setup/README.md)), no live `cpan`/`cpanm` network install was attempted to fix this — installing modules over the network is out of scope for a reproducible, offline-verifiable lesson and risks hanging in a sandboxed environment. This is documented honestly rather than faking DBI output.

## Concept (conceptual only, not run)

`DBI` (Database Independent interface) is Perl's standard database abstraction layer — one API, pluggable `DBD::*` driver modules per backend (`DBD::SQLite`, `DBD::mysql`, `DBD::Pg`, etc.). The typical usage pattern, **shown here as reference code only, not executed**, since the modules aren't available:

```perl
use strict;
use warnings;
use DBI;

my $dbh = DBI->connect("dbi:SQLite:dbname=app.db", "", "", { RaiseError => 1, AutoCommit => 1 });

$dbh->do(q{
    CREATE TABLE IF NOT EXISTS tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        done INTEGER NOT NULL DEFAULT 0
    )
});

my $sth = $dbh->prepare("INSERT INTO tasks (title) VALUES (?)");
$sth->execute("Buy milk");

my $rows = $dbh->selectall_arrayref("SELECT id, title, done FROM tasks", { Slice => {} });
for my $row (@$rows) {
    print "$row->{id}: $row->{title} (done=$row->{done})\n";
}

$dbh->disconnect;
```

This is why [22-Mini-Projects](../22-Mini-Projects/README.md)'s Task Tracker uses **file-based JSON persistence via `JSON::PP`** (confirmed bundled — see [10-File-Handling](../10-File-Handling/README.md)) instead of SQLite: it's the storage approach that's actually verifiable end-to-end in this exact environment, rather than a DBI code sample nobody can prove runs here.

## Common beginner mistakes

- Assuming `DBI` ships with core Perl — it does not; it's a very common but still separately-installed CPAN distribution, as confirmed by the failure above.
- Hardcoding a DSN/credentials directly in source rather than via environment variables or a config file kept out of version control.

## Best practices

- Always verify a module's presence (`perl -MModule -e "print 1"`) before depending on it in a script meant to run in an unfamiliar environment.
- Use `RaiseError => 1` (as shown above) so DBI errors become exceptions catchable with `eval`/`try` (see [09-Error-Handling](../09-Error-Handling/README.md)) instead of requiring manual `$dbh->err` checks after every call.
