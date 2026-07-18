#!/usr/bin/env perl
use strict;
use warnings;

# `package` declares a namespace; a `.pm` file is a module (one package,
# conventionally matching its filename/directory path, e.g. MathUtils.pm
# defines `package MathUtils`). `use Module qw(names)` loads it at COMPILE
# time and imports selected symbols; `require Module` loads at RUN time
# (useful for conditional loading) and does NOT import anything by itself.
use lib '.';                          # add this directory to @INC so the local .pm is found
use MathUtils qw(square cube average);

print "square(6)  = ", square(6), "\n";
print "cube(3)    = ", cube(3), "\n";
print "average    = ", average(2, 4, 6, 8), "\n";

# @INC is the list of directories Perl searches for `use`/`require`d files --
# printing it shows exactly where MathUtils.pm was found.
print "MathUtils.pm loaded from: $INC{'MathUtils.pm'}\n";

# require at runtime, conditionally
if (1) {
    require MathUtils;   # already loaded above, but this shows the syntax;
                          # require does NOT re-import symbols, only reloads if needed
    print "square via fully-qualified call: ", MathUtils::square(7), "\n";
}

# CPAN (conceptual): real third-party modules are installed with `cpan`
# or, more commonly today, `cpanm` (App::cpanminus), from the CPAN
# (Comprehensive Perl Archive Network) repository -- Perl's equivalent of
# PyPI/npm/RubyGems. This course deliberately avoids any CPAN install step
# for every lesson, relying only on modules already bundled with this
# environment's Perl distribution (JSON::PP, HTTP::Tiny, Test::More,
# threads, etc. -- each verified live in its own lesson) since this
# environment has no internet-based CPAN bootstrap available.
