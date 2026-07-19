use strict;
use warnings;
use Test::More;
use FindBin;
use lib "$FindBin::Bin/../lib";
use TaskStore;

# Use a throwaway JSON file in a temp location distinct from any real
# tasks.json, and clean it up afterward so test runs are repeatable.
my $test_db = "$FindBin::Bin/test_tasks.json";
unlink $test_db if -e $test_db;

my $store = TaskStore->new(path => $test_db);

is_deeply([ $store->list ], [], 'starts with no tasks');

my $t1 = $store->add('Buy milk');
is($t1->{id}, 1, 'first task gets id 1');
is($t1->{title}, 'Buy milk', 'title stored correctly');
is($t1->{done}, 0, 'new task is not done');

my $t2 = $store->add('Write tests');
is($t2->{id}, 2, 'second task gets id 2');

my @tasks = $store->list;
is(scalar @tasks, 2, 'list returns both tasks');

my $completed = $store->complete(1);
is($completed->{done}, 1, 'complete() marks task done');

($t1) = grep { $_->{id} == 1 } $store->list;
is($t1->{done}, 1, 'completed task persists as done in list()');

eval { $store->complete(999) };
like($@, qr/no task with id 999/, 'complete() dies on unknown id');

$store->remove(2);
@tasks = $store->list;
is(scalar @tasks, 1, 'remove() deletes the task');
is($tasks[0]{id}, 1, 'remaining task is the right one');

eval { $store->remove(999) };
like($@, qr/no task with id 999/, 'remove() dies on unknown id');

eval { $store->add('') };
like($@, qr/title must not be empty/, 'add() rejects empty title');

# Reload from disk in a fresh instance to prove persistence actually
# round-trips through the JSON file, not just in-memory state.
my $reloaded = TaskStore->new(path => $test_db);
@tasks = $reloaded->list;
is(scalar @tasks, 1, 'persisted state reloads correctly from disk');
is($tasks[0]{title}, 'Buy milk', 'reloaded task has correct title');
is($tasks[0]{done}, 1, 'reloaded task retains done status');

unlink $test_db if -e $test_db;

done_testing();
