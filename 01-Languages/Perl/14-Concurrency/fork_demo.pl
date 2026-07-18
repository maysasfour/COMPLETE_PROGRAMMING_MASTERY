#!/usr/bin/env perl
use strict;
use warnings;

my $pid = fork();
if (!defined $pid) {
    die "fork failed: $!\n";
} elsif ($pid == 0) {
    # child
    print "child pid $$: hello from the child\n";
    exit 0;
} else {
    print "parent pid $$: spawned child $pid\n";
    my $reaped = waitpid($pid, 0);
    print "parent: reaped pid $reaped, child exit status $?\n";
}
