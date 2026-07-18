#!/usr/bin/env perl
use strict;
use warnings;
use JSON::PP;

# HONESTY NOTE (checked live, not assumed): neither DBI nor DBD::SQLite is
# bundled with this Git-for-Windows Perl build.
#
#   $ perl -MDBI -e 1
#   Can't locate DBI.pm in @INC (you may need to install the DBI module) ...
#
#   $ perl -MDBD::SQLite -e 1
#   Can't locate DBD/SQLite.pm in @INC (you may need to install the DBD::SQLite module) ...
#
# Both are real, extremely common CPAN modules in production Perl (DBI is
# Perl's universal DB-driver-abstraction layer, exactly like Python's DB-API
# or Java's JDBC; DBD::SQLite is the SQLite driver plugged into it), but
# installing them here would need a working CPAN/cpanm bootstrap this
# environment does not have configured, and DBD::SQLite specifically compiles
# a C extension, which is a heavier ask than this course's other languages'
# already-bundled DB drivers. Rather than fake a DBI session that was never
# actually run, this lesson is kept honestly conceptual for the DBI API
# shape, and pairs it with a REAL, fully-run alternative: a tiny JSON-file
# "table" using JSON::PP (confirmed genuinely bundled, see Lesson 10),
# which is exactly the persistence strategy Lesson 22's mini-project uses.

# ---- Conceptual: what real DBI + DBD::SQLite code looks like ----
#
#   use DBI;
#   my $dbh = DBI->connect("dbi:SQLite:dbname=tasks.db", "", "",
#                           { RaiseError => 1, AutoCommit => 1 });
#   $dbh->do(q{
#       CREATE TABLE IF NOT EXISTS tasks (
#           id    INTEGER PRIMARY KEY AUTOINCREMENT,
#           title TEXT NOT NULL,
#           done  INTEGER NOT NULL DEFAULT 0
#       )
#   });
#
#   # ALWAYS use a placeholder (?) for any value coming from outside the
#   # program -- never string-interpolate user input into SQL. A parameterized
#   # statement like this is immune to the classic `'; DROP TABLE tasks; --`
#   # SQL-injection attack this repository demonstrates live in other
#   # language courses' own DBI/DB-API equivalents:
#   my $sth = $dbh->prepare("INSERT INTO tasks (title) VALUES (?)");
#   $sth->execute($title);
#
#   my $rows = $dbh->selectall_arrayref(
#       "SELECT id, title, done FROM tasks WHERE done = ?",
#       { Slice => {} }, 0
#   );
#   $dbh->disconnect;

# ---- Real, actually-run alternative: a JSON-file-backed "table" ----
my $path = "demo_tasks.json";

sub load_tasks {
    return [] unless -e $path;
    open(my $fh, '<', $path) or die "read failed: $!";
    local $/;                         # slurp mode
    my $json = <$fh>;
    close($fh);
    return decode_json($json);
}

sub save_tasks {
    my ($tasks) = @_;
    open(my $fh, '>', $path) or die "write failed: $!";
    print $fh encode_json($tasks);
    close($fh);
}

my $tasks = load_tasks();
push @$tasks, { id => scalar(@$tasks) + 1, title => "Learn Perl DBI conceptually", done => JSON::PP::false };
push @$tasks, { id => scalar(@$tasks) + 1, title => "Write parameterized queries always", done => JSON::PP::true };
save_tasks($tasks);

my $reloaded = load_tasks();
print "tasks persisted: ", scalar(@$reloaded), "\n";
for my $t (@$reloaded) {
    print "  #$t->{id}: $t->{title} [", ($t->{done} ? "done" : "pending"), "]\n";
}

unlink($path);
print "cleaned up $path\n";
