#!/usr/bin/env perl
use strict;
use warnings;
use threads;
use threads::shared;

# CONCURRENCY IN THIS ENVIRONMENT -- honestly documented, not assumed:
#
# fork() is genuinely usable on this Git-for-Windows-bundled Perl (verified
# live in the session that built this course: a real child process was
# created via fork(), printed from the child, and the parent successfully
# waitpid()'d on it). Windows Perl fork() is emulated with real OS threads
# under the hood rather than true copy-on-write UNIX fork -- functionally
# usable for this course's demo, but heavier and with more edge cases than
# native UNIX fork (e.g. it requires an explicit ithreads-enabled Perl
# build, which this Git-for-Windows Perl is: `perl -V` reports
# "useithreads=define").
#
# The `threads` module (real OS-level ithreads, not just fork's emulation
# layer) is confirmed available (`perl -Mthreads -e 1` succeeds with no
# install) and is used directly below, since it is the more idiomatic,
# more portable choice for this course's demo versus fork().

my $counter :shared = 0;   # threads::shared makes this scalar visible/lockable across threads

sub worker {
    my $id = shift;
    for (1..1000) {
        lock($counter);      # threads::shared lock -- without it this would race
        $counter++;
    }
    return "thread $id done";
}

my @workers = map { threads->create(\&worker, $_) } (1..4);
my @results = map { $_->join() } @workers;
print "$_\n" for @results;
print "final shared counter (4 threads x 1000 increments, properly locked): $counter\n";

# fork() demo -- kept small and simple given the emulation caveat above.
my $pid = fork();
if (!defined $pid) {
    print "fork() failed: $!\n";
} elsif ($pid == 0) {
    print "child process: PID $$\n";
    exit(0);
} else {
    my $reaped = waitpid($pid, 0);
    print "parent process: reaped child PID $reaped\n";
}
