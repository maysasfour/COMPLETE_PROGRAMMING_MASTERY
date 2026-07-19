#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib";
use TaskStore;

# CLI Task Tracker.
#
# Usage:
#   perl task_tracker.pl add "Buy milk"
#   perl task_tracker.pl list
#   perl task_tracker.pl done <id>
#   perl task_tracker.pl remove <id>
#
# Persists to tasks.json in the current working directory unless
# TASK_TRACKER_DB is set to another path (used by the test suite so
# tests don't clobber a real tasks.json).

my $db_path = $ENV{TASK_TRACKER_DB} // 'tasks.json';
my $store = TaskStore->new(path => $db_path);

my ($cmd, @rest) = @ARGV;

if (!defined $cmd) {
    print usage();
    exit 1;
}
elsif ($cmd eq 'add') {
    my $title = join ' ', @rest;
    my $task = eval { $store->add($title) };
    if ($@) { print "error: $@"; exit 1; }
    print "added #$task->{id}: $task->{title}\n";
}
elsif ($cmd eq 'list') {
    my @tasks = $store->list;
    if (!@tasks) {
        print "(no tasks)\n";
    }
    else {
        for my $t (@tasks) {
            printf "[%s] #%d %s\n", ($t->{done} ? 'x' : ' '), $t->{id}, $t->{title};
        }
    }
}
elsif ($cmd eq 'done') {
    my $id = $rest[0];
    my $task = eval { $store->complete($id) };
    if ($@) { print "error: $@"; exit 1; }
    print "completed #$task->{id}: $task->{title}\n";
}
elsif ($cmd eq 'remove') {
    my $id = $rest[0];
    eval { $store->remove($id) };
    if ($@) { print "error: $@"; exit 1; }
    print "removed #$id\n";
}
else {
    print usage();
    exit 1;
}

sub usage {
    return <<'USAGE';
Task Tracker -- a small CLI backed by JSON::PP file persistence.

Commands:
  add <title>    add a new task
  list           list all tasks
  done <id>      mark task <id> complete
  remove <id>    delete task <id>
USAGE
}
