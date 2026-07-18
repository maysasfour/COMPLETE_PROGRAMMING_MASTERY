#!/usr/bin/env perl
use strict;
use warnings;

# perldoc is Perl's built-in documentation reader: `perldoc perlintro`,
# `perldoc -f sprintf` (docs for a builtin function), `perldoc List::Util`
# (docs for an installed module). It reads the same POD (Plain Old
# Documentation) markup embedded in this very file's comments-with-structure
# convention, though this file keeps things simple and just comments.

print "Perl version: $]\n";      # $] is the running interpreter's version number
print "Perl version (v-string): $^V\n";
print "Hello, Complete-Programming-Mastery!\n";

# %INC records every module already loaded and the file it came from --
# useful for confirming *which* copy of a module actually got picked up.
print "strict.pm loaded from: $INC{'strict.pm'}\n";
